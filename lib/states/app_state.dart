import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_state.g.dart';

@riverpod
class DetailSelectState extends _$DetailSelectState {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}

@riverpod
class TemporaryReservationDate extends _$TemporaryReservationDate {
  @override
  DateTime? build() => null;

  void selectDate(DateTime? date) => state = date;
}

@Riverpod(keepAlive: true)
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  void selectDate(DateTime date) => state = date;
}

// @riverpod
// class BusinessHours extends _$BusinessHours {
//   @override
//   List<DateTime> build() {
//     List<DateTime> businessHour = [
//       DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
//           Settings.businessHourList[0]['hour'] as int, Settings.businessHourList[0]['minute'] as int),
//       DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
//           Settings.businessHourList[1]['hour'] as int, Settings.businessHourList[1]['minute'] as int)
//     ];

//     List<DateTime> timeSlots = [];
//     DateTime startTime = businessHour[0];
//     DateTime endTime = businessHour[1];

//     for (var time = startTime; time.isBefore(endTime); time = time.add(Duration(minutes: Settings.reservationRange))) {
//       timeSlots.add(time);
//     }

//     return timeSlots;
//   }
// }

@riverpod
class DragState extends _$DragState {
  @override
  bool build() => false;

  void dragStart() {
    state = true;
  }

  void dragEnd() => state = false;
}

@riverpod
class LoadingState extends _$LoadingState {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}
