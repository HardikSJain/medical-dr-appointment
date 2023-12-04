import 'package:dr_appointment/constants/routes.dart';
import 'package:dr_appointment/screens/backend_down_screen.dart';
import 'package:dr_appointment/screens/no_internet.dart';
import 'package:dr_appointment/screens/bottom_nav.dart';
import 'package:dr_appointment/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // check backend status
  Future<bool> checkBackendStatus() async {
    bool isBackendLive = await getBackendStatusAPI();
    return isBackendLive;
  }

  // check internet connectivity
  Future<bool> checkInternetConnectivity() async {
    final isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,

      // Splash Screen
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: const Icon(
          Icons.local_hospital_rounded,
          size: 25,
        ),
        splashIconSize: 200,
        nextScreen: FutureBuilder<Widget>(
          future: _checkConnectivity(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const BackendDownScreen();
            }
          },
        ),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),

      // routes
      routes: {
        homePageRoute: (context) => const BottomNav(),
      },
    );
  }

  // check connectivity and backend status
  Future<Widget> _checkConnectivity() async {
    bool isConnected = await checkInternetConnectivity();
    bool isBackendLive = await checkBackendStatus();

    if (!isConnected) {
      return const NoInternetScreen();
    } else if (!isBackendLive) {
      return const BackendDownScreen();
    } else {
      return const BottomNav();
    }
  }
}
