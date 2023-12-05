// ignore_for_file: use_build_context_synchronously

import 'package:dr_appointment/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime? selectedDate;
  String? selectedLocation;
  String? selectedTime;
  String? selectedHospital;
  String? selectedDoctor;
  bool isOnlineMeeting = false;
  TextEditingController ccEmailController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _screenScroll = ScrollController();
  List<Map<String, dynamic>> scheduledAppointments = [];

  Future<void> fetchAppointments() async {
    List<Map<String, dynamic>> apiResponse;
    apiResponse = await getListOfSchedules();
    setState(() {
      scheduledAppointments = apiResponse;
    });
  }

  Future<void> handleCreateSchedule() async {
    if (selectedDate == null ||
        selectedTime == null ||
        selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Map<String, dynamic> scheduleData = {
      "date":
          selectedDate != null ? selectedDate!.toString().substring(0, 10) : '',
      "time": selectedTime ?? '',
      "doc_name": selectedDoctor ?? '',
      "online_meeting": isOnlineMeeting ? 1 : 0,
      "email_cc": ccEmailController.text,
    };

    bool res = await createScheduleAPI(scheduleData);

    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Schedule added',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to create schedule',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    fetchAppointments();
  }

  Future<void> handleDeleteSchedule(id) async {
    bool res = await deleteScheduleAPI(id.toString());
    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Schedule deleted',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
      fetchAppointments();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to delete schedule',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> handleEditSchedule(
      appointedDate, time, doctor, email, onlineMeeting, id) async {
    // selectedDate = appointedDate;
    setState(() {
      selectedTime = time.toString();
      selectedDoctor = doctor.toString();
      ccEmailController.text = email;
      isOnlineMeeting = onlineMeeting == '0' ? true : false;
    });

    await handleDeleteSchedule(id);
  }

  @override
  void initState() {
    fetchAppointments();
    super.initState();
  }

  @override
  void dispose() {
    ccEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F5FC),
      body: SingleChildScrollView(
        controller: _screenScroll,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Create New Schedule',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      onConfirm: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate != null
                              ? selectedDate!.toString().substring(0, 10)
                              : 'Select a Date *',
                          style: TextStyle(
                            color: selectedDate != null
                                ? Colors.black
                                : Colors.grey[400],
                          ),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedLocation,
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                          });
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'Location',
                        ),
                        items: ['Mumbai', 'Borivali']
                            .map((location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedHospital,
                        onChanged: (value) {
                          setState(() {
                            selectedHospital = value;
                          });
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'Hospital',
                        ),
                        items: ['Jupiter', 'Fortis']
                            .map((location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedTime,
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value;
                          });
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'Time *',
                        ),
                        items: [
                          '9:00 AM',
                          '9:30 AM',
                          '10:00 AM',
                        ]
                            .map((time) => DropdownMenuItem(
                                  value: time,
                                  child: Text(time),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedDoctor,
                        onChanged: (value) {
                          setState(() {
                            selectedDoctor = value;
                          });
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'Doctor *',
                        ),
                        items: [
                          'Dr. Sharma',
                          'Dr. Agarwal',
                          'Dr. Asthana',
                        ]
                            .map((time) => DropdownMenuItem(
                                  value: time,
                                  child: Text(time),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Switch(
                                value: isOnlineMeeting,
                                onChanged: (value) {
                                  setState(() {
                                    isOnlineMeeting = value;
                                  });
                                },
                              ),
                              const Text(
                                'Online Meet',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: ccEmailController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'CC Email',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleCreateSchedule,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Add Schedule',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                const Text(
                  'Upcoming Schedules',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.offset - 100,
                          curve: Curves.linear,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.offset + 100,
                          curve: Curves.linear,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 500,
                  child: ListView(
                    // physics: NeverScrollableScrollPhysics(),
                    controller: _scrollController,
                    children: _buildAppointmentTiles(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAppointmentTiles() {
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
        title: Text(appointment['doc_name']!),
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

                _screenScroll.animateTo(
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
