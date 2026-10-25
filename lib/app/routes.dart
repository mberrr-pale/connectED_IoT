
import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../features/onboarding/presentation/splash_screen.dart';
import 'main_navigation.dart';

class AppRoutes {
  AppRoutes._();

  static Map<String, WidgetBuilder> get routes {
    return {
      AppConstants.splashRoute: (context) =>
          const SplashScreen(),
      AppConstants.homeRoute: (context) =>
          const MainNavigation(),
    };
  }
}
