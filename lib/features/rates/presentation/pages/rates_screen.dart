import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/core/di/di.dart';
import 'package:test_task/core/router/app_router.dart';
import 'package:test_task/core/utils/date_time_extension.dart';
import 'package:test_task/features/rates/domain/entities/currency.dart';
import 'package:test_task/features/rates/presentation/bloc/rates/rates_bloc.dart';
import 'package:test_task/features/rates/presentation/widgets/rates_error_widget.dart';
import 'package:test_task/features/rates/presentation/widgets/rates_loading_widget.dart';
import 'package:test_task/generated/l10n.dart';

@RoutePage()
class RatesScreen extends StatelessWidget {
  const RatesScreen({super.key});
  final double _rateContainerWidth = 80;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RatesBloc>(
      create: (_) => getIt<RatesBloc>()..add(InitRates()),
      child: BlocBuilder<RatesBloc, RatesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).currenciesRates),
              actions: [
                switch (state) {
                  RatesSuccess() => IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        AutoRouter.of(context)
                            .push(const RatesSettingsRoute())
                            .then((_) {
                          context.read<RatesBloc>().add(UpdateData());
                        });
                      },
                    ),
                  RatesState() => Container(),
                }
              ],
            ),
            body: switch (state) {
              RatesInProgress() => const RatesLoadingWidget(),
              RatesFailure failure => RatesErrorWidget(
                  errorText: failure.message,
                ),
              RatesSuccess s => ListView.builder(
                  itemCount: s.currencies
                          .where((element) => element.enabled ?? false)
                          .length +
                      1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: Row(
                          children: [
                            const Spacer(),
                            if (!s.hasNextDayCurrencies)
                              _ratesDate(DateTime.now()
                                  .subtract(const Duration(days: 1))),
                            _ratesDate(DateTime.now()),
                            if (s.hasNextDayCurrencies)
                              _ratesDate(
                                  DateTime.now().add(const Duration(days: 1))),
                          ],
                        ),
                        selected: true,
                      );
                    }
                    final currency = s.currencies
                        .where((element) => element.enabled ?? false)
                        .toList()[index - 1];
                    return ListTile(
                      title: _buildCurrencyRow(
                        context,
                        currency,
                        s.hasNextDayCurrencies,
                      ),
                    );
                  },
                ),
              RatesState() => Container(),
            },
          );
        },
      ),
    );
  }

  Widget _ratesDate(DateTime date) {
    return SizedBox(
      width: _rateContainerWidth,
      child: Text(
        date.format('dd.MM.yy'),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCurrencyRow(
      BuildContext context, Currency currency, bool hasNextDayCurrencies) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currency.abbr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                currency.name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (!hasNextDayCurrencies)
          SizedBox(
            width: _rateContainerWidth,
            child: Text(
              '${currency.previousDayRate?.value}',
              textAlign: TextAlign.center,
            ),
          ),
        SizedBox(
          width: _rateContainerWidth,
          child: Text(
            '${currency.rate?.value}',
            textAlign: TextAlign.center,
          ),
        ),
        if (hasNextDayCurrencies)
          SizedBox(
            width: _rateContainerWidth,
            child: Text(
              '${currency.nextDayRate?.value}',
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
