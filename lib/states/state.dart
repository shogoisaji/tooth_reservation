import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';
import 'package:tooth_reservation/models/logged_in_user.dart';
import 'package:tooth_reservation/models/settings.dart';

part 'state.g.dart';

@riverpod
Stream<Session?> sessionResponse(SessionResponseRef ref) {
  final supabase = Supabase.instance.client;
  return supabase.auth.onAuthStateChange.map((event) => event.session);
}

@riverpod
User? loggedInUserData(LoggedInUserDataRef ref) {
  final session = ref.watch(sessionResponseProvider);
  return session.when(
    loading: () => null,
    error: (_, __) => null,
    data: (d) => d?.user,
  );
}

@riverpod
LoggedInUser? loggedInUser(LoggedInUserRef ref) {
  final User? userData = ref.watch(loggedInUserDataProvider);
  if (userData == null) {
    return null;
  }
  return LoggedInUser(
    userId: userData.id,
    username: userData.userMetadata!['user_name'],
    email: userData.email ?? '',
    phoneNumber: userData.userMetadata!['phone_number'] ?? '電話番号未登録',
  );
}

@riverpod
class DetailSelectState extends _$DetailSelectState {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}

@Riverpod(keepAlive: true)
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  void selectDate(DateTime date) => state = date;
}

@riverpod
class BusinessHours extends _$BusinessHours {
  Settings settings = Settings();
  @override
  List<DateTime> build() {
    List<DateTime> businessHour = [
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          settings.businessHourList[0]['hour'] as int, settings.businessHourList[0]['minute'] as int),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          settings.businessHourList[1]['hour'] as int, settings.businessHourList[1]['minute'] as int)
    ];

    List<DateTime> timeSlots = [];
    DateTime startTime = businessHour[0];
    DateTime endTime = businessHour[1];

    for (var time = startTime; time.isBefore(endTime); time = time.add(Duration(minutes: 15))) {
      timeSlots.add(time);
    }

    return timeSlots;
  }
}
// @riverpod
// class BusinessHours extends _$BusinessHours {
//   @override
//   List<Map<String, int>> build() {
//     List<Map<String, int>> businessHour = [
//       {"hour": 8, "minuit": 30},
//       {"hour": 17, "minuit": 30}
//     ];

//     List<Map<String, int>> timeSlots = [];
//     DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
//         businessHour[0]["hour"]!, businessHour[0]["minuit"]!);
//     DateTime endTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, businessHour[1]["hour"]!,
//         businessHour[1]["minuit"]!);

//     for (var time = startTime; time.isBefore(endTime); time = time.add(Duration(minutes: 15))) {
//       timeSlots.add({"hour": time.hour, "minuit": time.minute});
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
class TimerNotifier extends _$TimerNotifier {
  Timer? timer;

  void start() {
    state = true;

    timer?.cancel();
    timer = Timer(Duration(seconds: 1), () {
      print('timer.........');
      state = false; // state更新でUI再構築
    });
  }

  void cancel() {
    timer?.cancel();
  }

  @override
  bool build() {
    return false;
  }
}

// final timerProvider = StateNotifierProvider<TimerNotifier, bool>(
//   (ref) => TimerNotifier()  
// );
