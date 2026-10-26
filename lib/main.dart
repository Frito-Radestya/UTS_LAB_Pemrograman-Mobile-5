import 'package:flutter/material.dart';

import 'app.dart';
import 'app_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final services = await AppServices.create();
  runApp(KageApp(services: services));
}
