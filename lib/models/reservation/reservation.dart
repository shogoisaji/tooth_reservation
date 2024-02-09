import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

@freezed
class Reservation with _$Reservation {
  const Reservation._();

  const factory Reservation({
    int? id,
    required DateTime date,
    String? userId,
    String? userName,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

  factory Reservation.validate({
    int? id,
    required DateTime date,
    String? userId,
    String? userName,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
  }) {
    if (userId == null && (userName == null || email == null)) {
      throw ArgumentError('ユーザーIDが無い場合、ユーザー名とEメールが必要です。');
    }
    return Reservation(
      id: id,
      date: date,
      userId: userId,
      userName: userName,
      email: email,
      phoneNumber: phoneNumber,
      createdAt: createdAt,
    );
  }
}
