// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_hour_setting_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessHourSettingDataImpl _$$BusinessHourSettingDataImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessHourSettingDataImpl(
      openTime: const TimeOfDayConverter()
          .fromJson(json['openTime'] as Map<String, dynamic>),
      closeTime: const TimeOfDayConverter()
          .fromJson(json['closeTime'] as Map<String, dynamic>),
      reservationMinuteInterval: json['reservationMinuteInterval'] as int,
    );

Map<String, dynamic> _$$BusinessHourSettingDataImplToJson(
        _$BusinessHourSettingDataImpl instance) =>
    <String, dynamic>{
      'openTime': const TimeOfDayConverter().toJson(instance.openTime),
      'closeTime': const TimeOfDayConverter().toJson(instance.closeTime),
      'reservationMinuteInterval': instance.reservationMinuteInterval,
    };
