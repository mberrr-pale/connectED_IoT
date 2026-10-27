import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import 'routes.dart';

class ConnectedIoTApp extends StatelessWidget {
  const ConnectedIoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppConstants.splashRoute,
      routes: AppRoutes.routes,
    );
  }
}
