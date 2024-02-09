import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tooth_reservation/models/reservation/reservation.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_repository.dart';

part 'reservation_list.g.dart';

@riverpod
Stream<List<Reservation>?> reservationListStream(ReservationListStreamRef ref) {
  final stream = ref.watch(supabaseRepositoryProvider).reservationListStream();
  return stream;
}

@riverpod
List<Reservation>? reservationList(ReservationListRef ref) {
  final reservationList = ref.watch(reservationListStreamProvider);
  print("reservationList: $reservationList");
  return reservationList.when(
    loading: () => [],
    error: (_, __) => [],
    data: (d) {
      print("reservationList: $d");
      return d;
    },
  );
}
