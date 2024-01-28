import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tooth_reservation/models/reservation.dart';

class ReservationService {
  final supabase = Supabase.instance.client;

  Future<String?> insertReservation(Reservation reservation) async {
    late dynamic response;
    if (reservation.userId == null && reservation.userName == null && reservation.email == null) {
      throw Exception('not login user & userName, email is null');
    }
    try {
      if (reservation.userId != null) {
        response = await supabase.from('reservation').insert([
          {
            'reservation_date': reservation.date.toIso8601String(),
            'user_id': reservation.userId,
          }
        ]).select();
      } else {
        response = await supabase.from('reservation').insert([
          {
            'reservation_date': reservation.date.toIso8601String(),
            'user_name': reservation.userName,
            'phone_number': reservation.phoneNumber,
            'email': reservation.email,
          }
        ]).select();
      }
      if (response == null || response.error != null) {
        throw response?.error ?? 'Response is null';
      }
      print('success insert reservation: ${response.data}');
      return response.data;
    } catch (err) {
      return err.toString();
    }
  }

  Stream<List<Reservation>> getReservationListAllStream() {
    return supabase
        .from('reservation')
        .stream(primaryKey: ['id']).map((maps) => maps.map((map) => Reservation.fromJson(map)).toList());
  }

  Future<List<Reservation>> getReservationListAll() async {
    try {
      final response = await supabase.from('reservation').select();
      final List<Reservation> reservationList = [];
      for (final reservation in response) {
        reservationList.add(Reservation.fromJson(reservation));
      }
      return reservationList;
    } catch (err) {
      throw err.toString();
    }
  }

  Future<List<Reservation>> getReservationList(DateTime date) async {
    try {
      final response = await supabase.from('reservation').select().eq('reservation_date', date.toIso8601String());
      final List<Reservation> reservationList = [];
      for (final reservation in response) {
        reservationList.add(Reservation.fromJson(reservation));
      }
      return reservationList;
    } catch (err) {
      throw err.toString();
    }
  }

  Future<String?> deleteReservation(String id) async {
    try {
      final response = await supabase.from('reservation').delete().eq('id', id).select();

      print('success delete reservation: ${response}');
      return null;
    } catch (err) {
      return err.toString();
    }
  }
}
