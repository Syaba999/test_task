import 'package:auto_route/auto_route.dart';
import 'package:test_task/features/rates/presentation/pages/rates_screen.dart';
import 'package:test_task/features/rates/presentation/pages/rates_settings_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/rates',
          page: RatesRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: '/settings',
          page: RatesSettingsRoute.page,
        ),
      ];
}
