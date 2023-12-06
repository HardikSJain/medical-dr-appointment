import 'package:dr_appointment/main.dart';
import 'package:dr_appointment/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ScheduleViewModel extends BaseViewModel {
  DateTime? selectedDate;
  String? selectedLocation;
  String? selectedTime;
  String? selectedHospital;
  String? selectedDoctor;
  String? selectedId;
  bool isOnlineMeeting = false;
  TextEditingController ccEmailController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ScrollController screenScroll = ScrollController();
  // final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> scheduledAppointments = [];

  Future<void> fetchAppointments() async {
    try {
      scheduledAppointments = await _apiService.getListOfSchedules();
      notifyListeners();
    } catch (e) {
      snackbarService.showSnackbar(
        message: 'Error fetching appointments: $e',
        title: 'Error',
      );
    }
  }

  ScheduleViewModel() {
    // constructor
    fetchAppointments();
  }

  Future<void> handleCreateSchedule() async {
    print(selectedDate);
    print(selectedTime);
    print(selectedDoctor);
    Map<String, dynamic> scheduleData;
    Map<String, dynamic> updateData;
    // if (selectedDate != null ||
    //     selectedTime != null ||
    //     selectedDoctor != null) {
    String date =
        selectedDate != null ? selectedDate.toString().substring(0, 10) : '';
    String time = selectedTime ?? '';
    String docName = selectedDoctor ?? '';

    scheduleData = {
      "date": selectedDate.toString().substring(0, 10),
      "time": selectedTime,
      "doc_name": selectedDoctor,
      "online_meeting": isOnlineMeeting ? 1 : 0,
      "email_cc": ccEmailController.text,
    };
    updateData = {
      "id": selectedId,
      "date": selectedDate.toString().substring(0, 10),
      "time": selectedTime,
      "doc_name": selectedDoctor,
      "online_meeting": isOnlineMeeting ? 1 : 0,
      "email_cc": ccEmailController.text,
    };
    // } else {
    //   snackbarService.showSnackbar(
    //     // title: 'Error',
    //     message: "Please fill in all required fields",
    //   );
    //   return;
    // }

    try {
      bool res;
      if (toEdit) {
        res = await _apiService.updateScheduleAPI(updateData);
      } else {
        res = await _apiService.createScheduleAPI(scheduleData);
      }

      // if (res) {
      //   snackbarService.showSnackbar(
      //     message: toEdit ? 'Schedule Updated' : 'Schedule added',
      //     title: 'Success',
      //   );
      // } else {
      //   snackbarService.showSnackbar(
      //     message: 'Failed to create schedule',
      //     title: 'Error',
      //   );
      // }

      fetchAppointments();
      selectedDate = null;
      selectedDoctor = null;
      selectedHospital = null;
      selectedId = null;
      selectedLocation = null;
      selectedTime = null;
    } catch (e) {
      snackbarService.showSnackbar(
        message: 'Error creating schedule: $e',
        title: 'Error',
      );
    }
  }

  Future<void> handleDeleteSchedule(String id) async {
    try {
      bool res = await _apiService.deleteScheduleAPI(id.toString());

      // if (res) {
      //   snackbarService.showSnackbar(
      //     message: 'Schedule deleted',
      //     title: 'Success',
      //     duration: Duration(seconds: 2),
      //   );
      //   fetchAppointments();
      // } else {
      //   snackbarService.showSnackbar(
      //     message: 'Failed to delete schedule',
      //     title: 'Error',
      //   );
      // }
    } catch (e) {
      // snackbarService.showSnackbar(
      //   message: 'Error deleting schedule: $e',
      //   title: 'Error',
      // );
    }
  }

  bool toEdit = false;

  Future<void> handleEditSchedule(
    appointedDate,
    time,
    doctor,
    email,
    onlineMeeting,
    id,
  ) async {
    selectedTime = time.toString();
    selectedDoctor = doctor.toString();
    ccEmailController.text = email;
    isOnlineMeeting = onlineMeeting == '0' ? true : false;
    selectedId = id;
    toEdit = true;
    notifyListeners();
  }

  List<Widget> buildAppointmentTiles() {
    Map<String, List<Map<String, dynamic>>> groupedAppointments = {};

    // appointments by date
    for (var appointment in scheduledAppointments) {
      String date = appointment['date']!;
      if (!groupedAppointments.containsKey(date)) {
        groupedAppointments[date] = [];
      }
      groupedAppointments[date]!.add(appointment);
    }

    return groupedAppointments.entries.map((entry) {
      String date = entry.key;
      List<Map<String, dynamic>> appointments = entry.value;

      return Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                date,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> appointment = appointments[index];
                return buildAppointmentTile(appointment);
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget buildAppointmentTile(Map<String, dynamic> appointment) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(appointment['doc_name']),
        subtitle: Text('${appointment['time']} | ${appointment['email_cc']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Edit
                selectedTime = null;
                selectedDoctor = "";
                ccEmailController.text = "";
                isOnlineMeeting = false;
                handleEditSchedule(
                  appointment['date'],
                  appointment['time'],
                  appointment['doc_name'],
                  appointment['email_cc'],
                  appointment['online_meeting'],
                  appointment['id'],
                );

                screenScroll.animateTo(
                  0.0, // Scroll to the top
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: Delete
                handleDeleteSchedule(appointment['id']);
              },
            ),
          ],
        ),
      ),
    );
  }
}
