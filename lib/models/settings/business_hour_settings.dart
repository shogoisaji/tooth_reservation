import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tooth_reservation/models/settings/business_hour_setting_data.dart';
import 'package:tooth_reservation/models/settings/load_setting_data.dart';

part 'business_hour_settings.g.dart';

@Riverpod(keepAlive: true)
BusinessHourSettings businessHourSettings(BusinessHourSettingsRef ref) {
  final BusinessHourSettingData? data = ref.watch(loadSettingDataProvider);
  if (data == null) {
    throw Exception('BusinessHourSettingData is null');
  }
  return BusinessHourSettings(
      openTime: data.openTime, closeTime: data.closeTime, reservationMinuteInterval: data.reservationMinuteInterval);
}

class BusinessHourSettings {
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final int reservationMinuteInterval;
  BusinessHourSettings({
    required this.openTime,
    required this.closeTime,
    required this.reservationMinuteInterval,
  });

  int openTimeMinuteRange() => (closeTime.hour * 60 + closeTime.minute) - (openTime.hour * 60 + openTime.minute);

  int get hourCount {
    final times = getReservationAvailableTimes();
    int count = 0;
    TimeOfDay? currentTime;
    for (TimeOfDay time in times) {
      if (currentTime == null) {
        currentTime = time;
        count++;
      } else {
        if (currentTime.hour != time.hour) {
          count++;
          currentTime = time;
        }
      }
    }
    return count;
  }

  int get minuteCount => 60 ~/ reservationMinuteInterval;

  List<TimeOfDay> getReservationAvailableTimes() {
    final List<TimeOfDay> availableTimes = [];
    int startMinutes = openTime.hour * 60 + openTime.minute;
    int endMinutes = closeTime.hour * 60 + closeTime.minute;
    for (int currentMinutes = startMinutes; currentMinutes < endMinutes; currentMinutes += reservationMinuteInterval) {
      availableTimes.add(TimeOfDay(hour: currentMinutes ~/ 60, minute: currentMinutes % 60));
    }
    return availableTimes;
  }
}
