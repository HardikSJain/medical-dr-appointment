import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final void Function(int) onMakeAppointmentPressed;

  HomePage({Key? key, required this.onMakeAppointmentPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F5FC),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blue,
          ),
          onPressed: () {
            onMakeAppointmentPressed(1);
          },
          child: const Text(
            "Make Appointment",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
