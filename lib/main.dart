import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:dr_appointment/constants/routes.dart';
import 'package:dr_appointment/screens/backend_down_screen.dart';
import 'package:dr_appointment/screens/no_internet.dart';
import 'package:dr_appointment/screens/bottom_nav.dart';
import 'package:dr_appointment/services/apiService.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  setupLocator();

  runApp(MyApp());
}

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
}

class MyApp extends StatelessWidget {
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
        nextScreen: MainView(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),

      // routes
      routes: {
        homePageRoute: (context) => const BottomNav(),
      },
    );
  }
}

class MainViewModel extends BaseViewModel {
  ApiService _apiService = ApiService(); // Instance of ApiService

  // check backend status
  Future<bool> checkBackendStatus() async {
    bool isBackendLive = await _apiService.getBackendStatusAPI();
    return isBackendLive;
  }

  // check internet connectivity
  Future<bool> checkInternetConnectivity() async {
    final isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected;
  }

  // check connectivity and backend status
  Future<Widget> checkConnectivityAndNavigate() async {
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

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => MainViewModel(),
      builder: (context, model, child) {
        return FutureBuilder<Widget>(
          future: model.checkConnectivityAndNavigate(),
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
        );
      },
    );
  }
}
