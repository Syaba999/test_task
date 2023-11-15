import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_task/generated/l10n.dart';

import 'core/router/app_router.dart';
import 'core/styles/app_theme.dart';

class RatesApp extends StatelessWidget {
  RatesApp({super.key});

  final AppRouter _appRouter = AppRouter();
  final AppTheme _appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rates Demo',
      theme: _appTheme.mainTheme,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      routerConfig: _appRouter.config(),
    );
  }
}
