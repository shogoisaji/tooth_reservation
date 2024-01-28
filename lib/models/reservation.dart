class Reservation {
  int id;
  DateTime date;
  String? userId;
  String? userName;
  String? email;
  String? phoneNumber;
  DateTime? createdAt;

  Reservation({
    required this.id,
    required this.date,
    this.userId,
    this.userName,
    this.email,
    this.phoneNumber,
    this.createdAt,
  }) {
    if (userId == null && (userName == null || email == null)) {
      throw Exception('userIdがnullの場合、userNameとemailのどちらかがnullです');
    }
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    if (json['user_id'] != null) {
      return Reservation(
        id: json['id'],
        date: DateTime.parse(json['reservation_date']),
        userId: json['user_id'],
        createdAt: DateTime.parse(json['created_at']),
      );
    }
    return Reservation(
      id: json['id'],
      date: DateTime.parse(json['reservation_date']),
      userName: json['user_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    if (userId != null) {
      return {
        'reservation_date': date.toIso8601String(),
        'user_id': userId,
        'created_at': createdAt?.toIso8601String(),
      };
    }
    if (userName == null || email == null) {
      throw Exception('userName, email is null');
    }
    return {
      'reservation_date': date.toIso8601String(),
      'user_name': userName,
      'email': email,
      'phone_number': phoneNumber,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
