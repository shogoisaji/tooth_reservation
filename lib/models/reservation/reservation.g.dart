// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationImpl _$$ReservationImplFromJson(Map<String, dynamic> json) => _$ReservationImpl(
      id: json['id'] as int?,
      reservationDate: DateTime.parse(json['reservation_date'] as String), // reservationDate -> reservation_date 修正
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ReservationImplToJson(_$ReservationImpl instance) => <String, dynamic>{
      'id': instance.id,
      'reservationDate': instance.reservationDate.toIso8601String(),
      'userId': instance.userId,
      'userName': instance.userName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
