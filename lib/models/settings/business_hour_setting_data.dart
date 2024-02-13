import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tooth_reservation/models/settings/converter/time_of_day_converter.dart';

part 'business_hour_setting_data.freezed.dart';
part 'business_hour_setting_data.g.dart';

@freezed
class BusinessHourSettingData with _$BusinessHourSettingData {
  const factory BusinessHourSettingData({
    @TimeOfDayConverter() required final TimeOfDay openTime,
    @TimeOfDayConverter() required final TimeOfDay closeTime,
    required final int reservationMinuteInterval,
  }) = _BusinessHourSettingData;

  factory BusinessHourSettingData.fromJson(Map<String, dynamic> json) => _$BusinessHourSettingDataFromJson(json);
}
