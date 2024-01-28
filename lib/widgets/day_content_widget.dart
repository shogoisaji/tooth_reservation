import 'package:flutter/material.dart';

class DayContentWidget extends StatelessWidget {
  final DateTime day;
  const DayContentWidget({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Text(day.day.toString()),
          Row(
            children: [
              Text('10:00'),
              Text('予約済み'),
            ],
          ),
        ],
      ),
    );
  }
}
