import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:message_app/view/auth/login_page.dart';
import 'package:message_app/view/main_app.dart';
import 'package:message_app/theme/app_state.dart';
import 'package:message_app/theme/app_theme.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

bool isLoggedIn = false;
FirebaseAnalytics analytics = FirebaseAnalytics();

/// Initial theme settings
bool intro = false;
bool themeMode = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Login Checking
  var firebaseAuth = FirebaseAuth.instance;
  if (firebaseAuth.currentUser != null) isLoggedIn = true;

  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ListenableProvider(
            create: (_) => ThemeState(),
          ),
        ],
        child: OverlaySupport.global(
          child: MyApp(),
        ),
      ),
    );
  }, FirebaseCrashlytics.instance.recordError);

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(
      builder: (context, themeState, child) => MaterialApp(
          themeMode:
          themeState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          title: 'FluFire',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          color: Colors.blue,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          home: isLoggedIn ? MainApp() : LoginPage()),
    );
  }
}
