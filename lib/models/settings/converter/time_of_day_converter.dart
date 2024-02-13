import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimeOfDayConverter implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int);
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay time) => {'hour': time.hour, 'minute': time.minute};
}
