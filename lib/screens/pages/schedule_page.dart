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

  void handleSendOtpButtonPress() {
    // TODO: Create entry
  }

  @override
  void dispose() {
    ccEmailController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> apiResponse = [
    {
      "id": "1",
      "date": "2022-12-12",
      "time": "4:45 PM",
      "doc_name": "Dr_name-10",
      "online_meeting": "0",
      "email_cc": "abc10@gmail.com ,xyz@gmail.com"
    },
    {
      "id": "1",
      "date": "2022-12-12",
      "time": "4:45 PM",
      "doc_name": "Dr_name-10",
      "online_meeting": "0",
      "email_cc": "abc10@gmail.com ,xyz@gmail.com"
    },
    {
      "id": "1",
      "date": "2022-12-12",
      "time": "4:45 PM",
      "doc_name": "Dr_name-10",
      "online_meeting": "0",
      "email_cc": "abc10@gmail.com ,xyz@gmail.com"
    },
    {
      "id": "1",
      "date": "2022-12-12",
      "time": "4:45 PM",
      "doc_name": "Dr_name-10",
      "online_meeting": "0",
      "email_cc": "abc10@gmail.com ,xyz@gmail.com"
    },
    {
      "id": "1",
      "date": "2022-12-12",
      "time": "4:45 PM",
      "doc_name": "Dr_name-10",
      "online_meeting": "0",
      "email_cc": "abc10@gmail.com ,xyz@gmail.com"
    },
    {
      "id": "1",
      "date": "2022-12-12",
      "time": "4:45 PM",
      "doc_name": "Dr_name-10",
      "online_meeting": "0",
      "email_cc": "abc10@gmail.com ,xyz@gmail.com"
    },
    {
      "id": "5",
      "date": "2025-12-12",
      "time": "4:45 PM",
      "doc_name": "Drname",
      "online_meeting": "0",
      "email_cc": "abc1@gmail.com ,xyz@gmail.com"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F5FC),
      body: SingleChildScrollView(
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
                  onPressed: handleSendOtpButtonPress,
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
    Map<String, List<Map<String, String>>> groupedAppointments = {};

    // appointments by date
    for (var appointment in apiResponse) {
      String date = appointment['date']!;
      if (!groupedAppointments.containsKey(date)) {
        groupedAppointments[date] = [];
      }
      groupedAppointments[date]!.add(appointment);
    }

    return groupedAppointments.entries.map((entry) {
      String date = entry.key;
      List<Map<String, String>> appointments = entry.value;

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
                Map<String, String> appointment = appointments[index];
                return buildAppointmentTile(appointment);
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget buildAppointmentTile(Map<String, String> appointment) {
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
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: Delete
              },
            ),
          ],
        ),
      ),
    );
  }
}
