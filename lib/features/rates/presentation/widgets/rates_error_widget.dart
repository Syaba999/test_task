import 'package:flutter/material.dart';

class RatesErrorWidget extends StatelessWidget {
  const RatesErrorWidget({super.key, this.errorText = ''});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorText),
    );
  }
}
