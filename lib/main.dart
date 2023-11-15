import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(RatesApp());
}
