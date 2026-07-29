import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lntb_app/app/app.dart';
import 'package:lntb_app/core/bootstrap/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppBootstrap.init();
  runApp(const LntbAppRoot());
}
