import 'package:flutter/material.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '予約',
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}
