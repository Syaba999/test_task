import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/core/di/di.dart';
import 'package:test_task/features/rates/presentation/bloc/settings/settings_bloc.dart';
import 'package:test_task/features/rates/presentation/widgets/rates_loading_widget.dart';
import 'package:test_task/generated/l10n.dart';

@RoutePage()
class RatesSettingsScreen extends StatelessWidget {
  const RatesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).currenciesSettings),
      ),
      body: BlocProvider(
        create: (_) => getIt<SettingsBloc>()..add(InitSettings()),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return switch (state) {
              SettingsSuccess s => ReorderableListView.builder(
                  itemCount: s.currencies.length,
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final currency = s.currencies[index];
                    return ListTile(
                      key: ValueKey(currency),
                      title: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currency.abbr,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  currency.name,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: currency.enabled ?? false,
                            onChanged: (bool value) {
                              context
                                  .read<SettingsBloc>()
                                  .add(ToggleEnabled(currency: currency));
                            },
                          ),
                          ReorderableDragStartListener(
                            index: index,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.drag_handle,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    context.read<SettingsBloc>().add(
                          ChangeOrder(
                            oldIndex: oldIndex,
                            newIndex:
                                newIndex > oldIndex ? newIndex - 1 : newIndex,
                          ),
                        );
                  },
                ),
              SettingsState() => const RatesLoadingWidget(),
            };
            return Center(
              child: Text(S.of(context).currenciesSettings),
            );
          },
        ),
      ),
    );
  }
}
