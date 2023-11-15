import 'package:flutter/material.dart';

class RatesLoadingWidget extends StatelessWidget {
  const RatesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
