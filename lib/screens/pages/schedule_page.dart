// ignore_for_file: use_build_context_synchronously

import 'package:dr_appointment/screens/pages/scheduleViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:stacked/stacked.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScheduleViewModel>.reactive(
      viewModelBuilder: () => ScheduleViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE2F5FC),
          body: SingleChildScrollView(
            controller: model.scrollController,
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
                            model.selectedDate = date;
                            model.notifyListeners();
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
                              model.selectedDate != null
                                  ? model.selectedDate!
                                      .toString()
                                      .substring(0, 10)
                                  : 'Select a Date *',
                              style: TextStyle(
                                color: model.selectedDate != null
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
                            value: model.selectedLocation,
                            onChanged: (value) {
                              model.selectedLocation = value;
                              model.notifyListeners();
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
                            value: model.selectedHospital,
                            onChanged: (value) {
                              model.selectedHospital = value;
                              model.notifyListeners();
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
                            value: model.selectedTime,
                            onChanged: (value) {
                              model.selectedTime = value;
                              model.notifyListeners();
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
                            value: model.selectedDoctor,
                            onChanged: (value) {
                              model.selectedDoctor = value;
                              model.notifyListeners();
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
                                    value: model.isOnlineMeeting,
                                    onChanged: (value) {
                                      model.isOnlineMeeting = value;
                                      model.notifyListeners();
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
                            controller: model.ccEmailController,
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
                      onPressed: model.handleCreateSchedule,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
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
                            model.scrollController.animateTo(
                              model.scrollController.offset - 100,
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: () {
                            model.scrollController.animateTo(
                              model.scrollController.offset + 100,
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
                        controller: model.scrollController,
                        children: model.buildAppointmentTiles(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
