// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_in_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoggedInUserImpl _$$LoggedInUserImplFromJson(Map<String, dynamic> json) =>
    _$LoggedInUserImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$$LoggedInUserImplToJson(_$LoggedInUserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };
