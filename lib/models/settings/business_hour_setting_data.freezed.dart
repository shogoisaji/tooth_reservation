// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_hour_setting_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BusinessHourSettingData _$BusinessHourSettingDataFromJson(
    Map<String, dynamic> json) {
  return _BusinessHourSettingData.fromJson(json);
}

/// @nodoc
mixin _$BusinessHourSettingData {
  @TimeOfDayConverter()
  TimeOfDay get openTime => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get closeTime => throw _privateConstructorUsedError;
  int get reservationMinuteInterval => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessHourSettingDataCopyWith<BusinessHourSettingData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessHourSettingDataCopyWith<$Res> {
  factory $BusinessHourSettingDataCopyWith(BusinessHourSettingData value,
          $Res Function(BusinessHourSettingData) then) =
      _$BusinessHourSettingDataCopyWithImpl<$Res, BusinessHourSettingData>;
  @useResult
  $Res call(
      {@TimeOfDayConverter() TimeOfDay openTime,
      @TimeOfDayConverter() TimeOfDay closeTime,
      int reservationMinuteInterval});
}

/// @nodoc
class _$BusinessHourSettingDataCopyWithImpl<$Res,
        $Val extends BusinessHourSettingData>
    implements $BusinessHourSettingDataCopyWith<$Res> {
  _$BusinessHourSettingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openTime = null,
    Object? closeTime = null,
    Object? reservationMinuteInterval = null,
  }) {
    return _then(_value.copyWith(
      openTime: null == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      closeTime: null == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      reservationMinuteInterval: null == reservationMinuteInterval
          ? _value.reservationMinuteInterval
          : reservationMinuteInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessHourSettingDataImplCopyWith<$Res>
    implements $BusinessHourSettingDataCopyWith<$Res> {
  factory _$$BusinessHourSettingDataImplCopyWith(
          _$BusinessHourSettingDataImpl value,
          $Res Function(_$BusinessHourSettingDataImpl) then) =
      __$$BusinessHourSettingDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@TimeOfDayConverter() TimeOfDay openTime,
      @TimeOfDayConverter() TimeOfDay closeTime,
      int reservationMinuteInterval});
}

/// @nodoc
class __$$BusinessHourSettingDataImplCopyWithImpl<$Res>
    extends _$BusinessHourSettingDataCopyWithImpl<$Res,
        _$BusinessHourSettingDataImpl>
    implements _$$BusinessHourSettingDataImplCopyWith<$Res> {
  __$$BusinessHourSettingDataImplCopyWithImpl(
      _$BusinessHourSettingDataImpl _value,
      $Res Function(_$BusinessHourSettingDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openTime = null,
    Object? closeTime = null,
    Object? reservationMinuteInterval = null,
  }) {
    return _then(_$BusinessHourSettingDataImpl(
      openTime: null == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      closeTime: null == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      reservationMinuteInterval: null == reservationMinuteInterval
          ? _value.reservationMinuteInterval
          : reservationMinuteInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessHourSettingDataImpl implements _BusinessHourSettingData {
  const _$BusinessHourSettingDataImpl(
      {@TimeOfDayConverter() required this.openTime,
      @TimeOfDayConverter() required this.closeTime,
      required this.reservationMinuteInterval});

  factory _$BusinessHourSettingDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessHourSettingDataImplFromJson(json);

  @override
  @TimeOfDayConverter()
  final TimeOfDay openTime;
  @override
  @TimeOfDayConverter()
  final TimeOfDay closeTime;
  @override
  final int reservationMinuteInterval;

  @override
  String toString() {
    return 'BusinessHourSettingData(openTime: $openTime, closeTime: $closeTime, reservationMinuteInterval: $reservationMinuteInterval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessHourSettingDataImpl &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime) &&
            (identical(other.reservationMinuteInterval,
                    reservationMinuteInterval) ||
                other.reservationMinuteInterval == reservationMinuteInterval));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, openTime, closeTime, reservationMinuteInterval);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessHourSettingDataImplCopyWith<_$BusinessHourSettingDataImpl>
      get copyWith => __$$BusinessHourSettingDataImplCopyWithImpl<
          _$BusinessHourSettingDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessHourSettingDataImplToJson(
      this,
    );
  }
}

abstract class _BusinessHourSettingData implements BusinessHourSettingData {
  const factory _BusinessHourSettingData(
          {@TimeOfDayConverter() required final TimeOfDay openTime,
          @TimeOfDayConverter() required final TimeOfDay closeTime,
          required final int reservationMinuteInterval}) =
      _$BusinessHourSettingDataImpl;

  factory _BusinessHourSettingData.fromJson(Map<String, dynamic> json) =
      _$BusinessHourSettingDataImpl.fromJson;

  @override
  @TimeOfDayConverter()
  TimeOfDay get openTime;
  @override
  @TimeOfDayConverter()
  TimeOfDay get closeTime;
  @override
  int get reservationMinuteInterval;
  @override
  @JsonKey(ignore: true)
  _$$BusinessHourSettingDataImplCopyWith<_$BusinessHourSettingDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
