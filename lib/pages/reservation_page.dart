import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tooth_reservation/animations/calender_scale_animation.dart';
import 'package:tooth_reservation/models/config.dart';
import 'package:tooth_reservation/models/reservation/reservation.dart';
import 'package:tooth_reservation/models/reservation/reservation_list.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_auth_repository.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_repository.dart';
import 'package:tooth_reservation/states/app_state.dart';
import 'package:tooth_reservation/theme/color_theme.dart';
import 'package:tooth_reservation/widgets/loading.dart';
import 'package:tooth_reservation/widgets/reservation_select_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReservationPage extends HookConsumerWidget {
  const ReservationPage({super.key});

  static const double minWidth = 350;
  static const double maxWidth = 450;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationListState = useState<ReservationListState>(ReservationListState());
    // reservationListのstreamを監視
    useEffect(() {
      reservationListState.value = ref.watch(reservationListProvider);
      if (reservationListState.value.hasError) {
        print('reservationListState: ${reservationListState.value.errorMessage}');
      } else if (reservationListState.value.isLoading) {
        print('reservationListState: loading');
      } else {
        print('reservationListState: complete fetch');
      }
      return;
    }, [ref.watch(reservationListProvider)]);
    final w = MediaQuery.sizeOf(context).width;
    final isDragging = useState<bool>(false);
    final _calenderWidth = MediaQuery.sizeOf(context).width < minWidth
        ? minWidth
        : MediaQuery.sizeOf(context).width > maxWidth
            ? maxWidth
            : MediaQuery.sizeOf(context).width;
    final selectedMonth = useState<Map<String, int>>({"year": DateTime.now().year, "month": DateTime.now().month});
    final isCurrentMonthSelected = useState<bool>(true);

    // 選択月の初日の曜日を取得
    int getFirstWeekDay() {
      return DateTime(selectedMonth.value["year"]!, selectedMonth.value["month"]!).weekday;
    }

    // 選択月の日付をリストで生成
    List<DateTime> daysListGenerate(int year, int month) {
      final List<DateTime> daysList = [];
      for (int i = 1; i < DateTime(year, month + 1, 0).day + 1; i++) {
        daysList.add(DateTime(year, month, i));
      }
      return daysList;
    }

    // 選択月が現在の月かどうかをチェック
    void checkIfCurrentMonth() {
      if (selectedMonth.value["year"] == DateTime.now().year && selectedMonth.value["month"] == DateTime.now().month) {
        isCurrentMonthSelected.value = true;
      } else {
        isCurrentMonthSelected.value = false;
      }
    }

    // loading
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(loadingStateProvider.notifier).show();
      });
      if (reservationList != []) {
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(loadingStateProvider.notifier).hide();
        });
      }
      return () {};
    }, []);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.8, 0.3),
          end: Alignment(0.3, 0.0),
          colors: [
            Color(MyColor.mint1),
            Color(MyColor.mint2),
          ],
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: -10,
                  child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        // border: Border.all(width: 2.0, color: Colors.green[300]!.withOpacity(0.5)),
                      )),
                ),
                Positioned(
                  top: 200,
                  right: -30,
                  child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      )),
                ),
                Positioned(
                  bottom: 80,
                  left: 10,
                  child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      )),
                ),
                Center(
                  child: SizedBox(
                    width: _calenderWidth,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.circleChevronLeft,
                                    color: isCurrentMonthSelected.value ? Colors.transparent : Colors.green[900]),
                                onPressed: () {
                                  if (isCurrentMonthSelected.value) {
                                    return;
                                  }
                                  int newMonth = selectedMonth.value["month"]! - 1;
                                  int newYear = selectedMonth.value["year"]!;
                                  if (newMonth == 0) {
                                    newMonth = 12;
                                    newYear = newYear - 1;
                                  }
                                  selectedMonth.value = {"year": newYear, "month": newMonth};
                                  checkIfCurrentMonth();
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  selectedMonth.value = {"year": DateTime.now().year, "month": DateTime.now().month};
                                },
                                child: Text(
                                  "${selectedMonth.value["year"]}年${selectedMonth.value["month"]}月",
                                  style: TextStyle(color: Colors.green[900], fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.circleChevronRight, color: Colors.green[900]),
                                onPressed: () {
                                  int newMonth = selectedMonth.value["month"]! + 1;
                                  int newYear = selectedMonth.value["year"]!;
                                  if (newMonth == 13) {
                                    newMonth = 1;
                                    newYear = newYear + 1;
                                  }
                                  selectedMonth.value = {"year": newYear, "month": newMonth};
                                  checkIfCurrentMonth();
                                },
                              ),
                            ],
                          ),
                        ),
                        // 曜日表示
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...List.generate(
                              7,
                              (index) => Container(
                                width: _calenderWidth / 7.5,
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1.5, color: Colors.white),
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.transparent),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                                    child: Text(
                                        [
                                          "日",
                                          "月",
                                          "火",
                                          "水",
                                          "木",
                                          "金",
                                          "土",
                                        ][index],
                                        style: TextStyle(
                                            color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // カレンダー表示
                        Expanded(
                          child: GridView.builder(
                              // physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                              itemCount:
                                  daysListGenerate(selectedMonth.value["year"]!, selectedMonth.value["month"]!).length +
                                      getFirstWeekDay(),
                              itemBuilder: (BuildContext context, int index) {
                                final DateTime? day = index < getFirstWeekDay()
                                    ? null
                                    : daysListGenerate(selectedMonth.value["year"]!, selectedMonth.value["month"]!)[
                                        index - getFirstWeekDay()];
                                int count = reservationListState.value.data == null
                                    ? 0
                                    : reservationListState.value.data!.where((reservation) {
                                        // 時間を無視して日付のみ
                                        final convertDate = DateTime(
                                          reservation.reservationDate.year,
                                          reservation.reservationDate.month,
                                          reservation.reservationDate.day,
                                        );
                                        return convertDate == day;
                                      }).length;
                                final Color? color = count == 0
                                    ? Colors.white
                                    : Colors.red[100 * (count + 1) > 900 ? 900 : 100 * (count + 1)];
                                return index < getFirstWeekDay()
                                    ? Container()
                                    : DayContent(day!, color!, selectedMonth.value);
                              }),
                        ),
                        const TemporaryDateWidget(),
                        const SizedBox(
                          height: 150,
                        )
                      ],
                    ),
                  ),
                ),
                ref.watch(detailSelectStateProvider) ? const ReservationSelectWidget() : Container(),
              ],
            ),
          ),
          ref.watch(temporaryReservationDateProvider) == null
              ? Positioned(
                  bottom: ref.watch(detailSelectStateProvider) ? 65 : 45,
                  right: w * 0.5 - 50,
                  child: ref.watch(detailSelectStateProvider)
                      ? Draggable(
                          data: 1,
                          onDragStarted: () {
                            isDragging.value = true;
                          },
                          onDragEnd: (details) {
                            isDragging.value = false;
                          },
                          feedback: Lottie.asset(
                            'assets/lottie/hurt_tooth.json',
                            width: 95,
                          ),
                          childWhenDragging: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          child: Lottie.asset(
                            'assets/lottie/hurt_tooth.json',
                            width: 95,
                          ),
                        )
                      : Lottie.asset(
                          'assets/lottie/hurt_tooth.json',
                          width: 95,
                        ),
                )
              : Container(),
          Positioned(
            bottom: -10,
            child: SizedBox(
              width: w,
              height: 135,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      height: 97,
                      decoration: const BoxDecoration(
                        color: Color(0xffF9717C),
                        border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IgnorePointer(
                      child: Image.asset('assets/images/gum.png',
                          height: 135, width: w < 400 ? w : 400, fit: BoxFit.fill)),
                  Expanded(
                    child: Container(
                      height: 97,
                      decoration: const BoxDecoration(
                        color: Color(0xffF9717C),
                        border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ref.read(detailSelectStateProvider) &&
                  !isDragging.value &&
                  ref.watch(temporaryReservationDateProvider) == null
              ? Align(
                  alignment: Alignment(0, 0.91),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blue[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text('ドラッグ',
                        style: TextStyle(color: Colors.blue[900], fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                )
              : Container(),
          ref.watch(detailSelectStateProvider) &&
                  !isDragging.value &&
                  ref.watch(temporaryReservationDateProvider) == null
              ? Positioned(
                  bottom: 60,
                  right: w * 0.5 - 75,
                  child: IgnorePointer(
                      child: Lottie.asset(
                    'assets/lottie/pickUp.json',
                    width: 150,
                  )))
              : Container(),
          const Loading(),
        ],
      ),
    );
  }
}

class DayContent extends HookConsumerWidget {
  final DateTime day;
  final Color color;
  final Map<String, int> selectedMonth;
  const DayContent(this.day, this.color, this.selectedMonth, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = GlobalKey();
    final isScale = useState<bool>(false);
    final containerSize = useState<Size>(Size.zero);
    final isReserved = useState<bool>(false);
    final tempoDay = ref.watch(temporaryReservationDateProvider);

    void getContainerSize() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
        containerSize.value = renderBox?.size ?? Size.zero;
      });
    }

    void reservedCheck() {
      if (tempoDay == null) {
        isReserved.value = false;
      }
      if (day.year == tempoDay!.year && day.month == tempoDay.month && day.day == tempoDay.day) {
        isReserved.value = true;
        print('reservedCheck: $tempoDay');
        return;
      }
      isReserved.value = false;
    }

    useEffect(() {
      if (tempoDay != null) {
        reservedCheck();
      } else {
        isReserved.value = false;
      }
      return () {};
    }, [ref.watch(temporaryReservationDateProvider), selectedMonth]);

    useEffect(() {
      getContainerSize();
      return () {};
    }, [key]);

    return CalenderScaleAnimation(
      isScale: isScale.value,
      child: GestureDetector(
        onTap: () {
          ref.read(selectedDateProvider.notifier).selectDate(day);
          ref.read(detailSelectStateProvider.notifier).show();
        },
        child: Container(
          key: key,
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              border: Border.all(width: 4.0, color: isReserved.value ? Colors.blue[800]! : color),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: isReserved.value ? Colors.blue[800]!.withOpacity(0.5) : Colors.transparent,
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 0),
                ),
              ]),
          child: Stack(
            children: [
              Positioned(
                bottom: -5,
                right: -2,
                child: isReserved.value
                    ? Transform.rotate(
                        angle: 0.2,
                        child: Image.asset('assets/images/reservedTooth.png',
                            width: containerSize.value.width * 0.7,
                            height: containerSize.value.width * 0.8,
                            fit: BoxFit.fill),
                      )
                    : Container(),
              ),
              Padding(
                padding: isReserved.value
                    ? const EdgeInsets.only(top: 0.0, left: 0.0)
                    : const EdgeInsets.only(top: 0.0, left: 1.0),
                child: Text(day.day.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TemporaryDateWidget extends HookConsumerWidget {
  const TemporaryDateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempoDay = ref.watch(temporaryReservationDateProvider);
    final w = MediaQuery.sizeOf(context).width;

    String formatDate(DateTime date) {
      return "${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute == 0 ? '00' : date.minute}";
    }

    final String formattedDate = tempoDay != null ? formatDate(tempoDay) : "";

    return Container(
        padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(30.0),
          ),
          color: const Color(MyColor.mint3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: tempoDay != null
                  ? Column(
                      children: [
                        Text('選択中の予約日時',
                            style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.normal, fontSize: 18)),
                        Container(
                          // width: double.infinity,
                          margin: const EdgeInsets.only(top: 4.0),
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.black.withOpacity(0.1),
                          ),
                          child: Container(
                              width: double.infinity,
                              height: w > Config.breakPoint ? 50 : 40,
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.9),
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                    offset: const Offset(0, 0.5),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(formattedDate,
                                        style: TextStyle(
                                            color: Colors.green[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: w > 700 ? 24 : 20)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      child: Icon(Icons.cancel, color: Colors.green[300]),
                                      onTap: () {
                                        ref.read(temporaryReservationDateProvider.notifier).selectDate(null);
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    )
                  : Center(
                      child: Text('予約したい日を選択してください',
                          style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                              fontSize: w > Config.breakPoint ? 22 : 18)),
                    ),
            ),
            InkWell(
              onTap: () {
                if (tempoDay == null) {
                  return;
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(tempoDay);
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.only(left: 12.0),
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: tempoDay != null ? const Color(MyColor.green) : Colors.grey[500],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    const Text('予約', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
          ],
        ));
  }
}

class CustomDialog extends HookConsumerWidget {
  final DateTime date;
  const CustomDialog(this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _client = ref.watch(supabaseRepositoryProvider);
    String formatDate(DateTime date) {
      return "${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute == 0 ? '00' : date.minute}";
    }

    final String formattedDate = formatDate(date);
    final isLoggedIn = ref.watch(supabaseAuthRepositoryProvider).authUser != null;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Text('予約確認'),
      content: Text('$formattedDate\nで予約しますか？', style: const TextStyle(fontSize: 20)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('キャンセル', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () async {
            if (!isLoggedIn) {
              context.pop();
              context.go('/home/reservation/reservation_form');
              return;
            }
            context.pop();
            try {
              final User? user = ref.watch(supabaseAuthRepositoryProvider).authUser;
              if (user == null) {
                return;
              }
              final res = Reservation(
                id: 1,
                userId: user.id,
                userName: null,
                email: null,
                phoneNumber: null,
                reservationDate: date,
              );
              final data = await _client.insertReservation(res);
              ref.read(temporaryReservationDateProvider.notifier).selectDate(null);
              print('insert result:$data');
            } catch (e) {
              print('エラーが発生しました: $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
          ),
          child: Text(isLoggedIn ? '予約する' : '予約フォーム',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ],
    );
  }
}
