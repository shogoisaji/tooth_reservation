import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tooth_reservation/models/reservation/reservation.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_repository.dart';

part 'reservation_list.g.dart';

class ReservationListState {
  final List<Reservation>? data;
  final String? errorMessage;

  ReservationListState({this.data, this.errorMessage});

  bool get isLoading => data == null && errorMessage == null;
  bool get hasError => errorMessage != null;
}

@riverpod
Stream<List<Reservation>?> reservationListStream(ReservationListStreamRef ref) {
  return ref.watch(supabaseRepositoryProvider).reservationListStream();
}

@riverpod
ReservationListState reservationList(ReservationListRef ref) {
  final reservationList = ref.watch(reservationListStreamProvider);
  return reservationList.when(
    loading: () => ReservationListState(),
    error: (e, __) => ReservationListState(errorMessage: "reservationList fetch error:$e"),
    data: (d) => ReservationListState(data: d),
  );
}
