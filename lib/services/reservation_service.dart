import 'package:supabase_flutter/supabase_flutter.dart';

class ReservationService {
  final supabase = Supabase.instance.client;

  Future<String?> insertReservation(
      String reservationDate, String? userId, String? userName, String? email, String? phoneNumber) async {
    if (userId == null && (userName == null || email == null || phoneNumber == null)) {
      throw Exception('必要な情報が不足しています');
    }
    try {
      final response = await supabase.from('reservation').insert([
        {
          'reservation_date': reservationDate,
          'user_id': userId,
          'user_name': userName,
          'phone_number': phoneNumber,
          'email': email,
        }
      ]);
      if (response.error != null) {
        throw response.error!;
      }
      return null;
    } catch (err) {
      return err.toString();
    }
  }
}
