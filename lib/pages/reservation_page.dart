import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tooth_reservation/animations/calender_scale_animation.dart';
import 'package:tooth_reservation/models/reservation.dart';
import 'package:tooth_reservation/services/reservation_service.dart';
import 'package:tooth_reservation/states/state.dart';
import 'package:tooth_reservation/widgets/loading.dart';
import 'package:tooth_reservation/widgets/reservation_select_widget.dart';

class ReservationPage extends HookConsumerWidget {
  const ReservationPage({super.key});

  final double minWidth = 400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShow = ref.watch(loadingStateProvider);
    final reservationList = useState<List<Reservation>>([]);
    final ReservationService service = ReservationService();
    final _calenderWidth =
        MediaQuery.of(context).size.width * 0.5 < minWidth ? minWidth : MediaQuery.of(context).size.width * 0.5;
    final selectedMonth = useState<Map<String, int>>({"year": DateTime.now().year, "month": DateTime.now().month});
    final isDragCompleted = useState<bool>(false);
    int getFirstWeekDay() {
      return DateTime(selectedMonth.value["year"]!, selectedMonth.value["month"]!).weekday;
    }

    List<DateTime> daysListGenerate(int year, int month) {
      final List<DateTime> daysList = [];
      for (int i = 1; i < DateTime(year, month + 1, 0).day + 1; i++) {
        daysList.add(DateTime(year, month, i));
      }
      return daysList;
    }

    String selectedDateConvert() {
      final DateTime? selectTime = ref.watch(temporaryReservationDateProvider);
      final DateTime? selectDate = ref.watch(selectedDateProvider);
      if (selectTime == null || selectDate == null) {
        return "not selected";
      }
      return "${selectDate.month}/${selectDate.day} ${selectTime.hour}:${selectTime.minute}";
    }

    useEffect(() {
      final StreamSubscription<List<Reservation>> stream = service.getReservationListAllStream().listen((event) {
        print('event: ${event.length}');
        reservationList.value = event;
      });
      return () {
        stream.cancel();
      };
    }, []);

    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: Container(
              width: _calenderWidth,
              color: Colors.grey[100],
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          int newMonth = selectedMonth.value["month"]! - 1;
                          int newYear = selectedMonth.value["year"]!;
                          if (newMonth == 0) {
                            newMonth = 12;
                            newYear = newYear - 1;
                          }
                          selectedMonth.value = {"year": newYear, "month": newMonth};
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          selectedMonth.value = {"year": DateTime.now().year, "month": DateTime.now().month};
                        },
                        child: Text(
                          "${selectedMonth.value["year"]}年${selectedMonth.value["month"]}月",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          int newMonth = selectedMonth.value["month"]! + 1;
                          int newYear = selectedMonth.value["year"]!;
                          if (newMonth == 13) {
                            newMonth = 1;
                            newYear = newYear + 1;
                          }
                          selectedMonth.value = {"year": newYear, "month": newMonth};
                        },
                      ),
                    ],
                  ),
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
                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Colors.blue[100]),
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
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
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
                          int count = reservationList.value.where((reservation) {
                            // 時間を無視して日付のみ
                            final convertDate = DateTime(
                              reservation.date.year,
                              reservation.date.month,
                              reservation.date.day,
                            );
                            return convertDate == day;
                          }).length;
                          final Color? color = count == 0
                              ? Colors.red[100]
                              : Colors.blue[100 * (count + 1) > 900 ? 900 : 100 * (count + 1)];
                          return index < getFirstWeekDay() ? Container() : DayContent(day!, color!);
                        }),
                  ),
                  const SizedBox(
                    width: 60,
                    height: 60,
                  ),
                  TemporaryDateWidget(),
                  ElevatedButton(
                    onPressed: () async {
                      ref.read(temporaryReservationDateProvider.notifier).selectDate(null);
                    },
                    child: Text('reset'),
                  ),
                  Text(selectedDateConvert()),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final String? userId = ref.read(loggedInUserProvider)?.userId;
                        final res = Reservation(
                          id: 1,
                          userId: userId,
                          userName: 'test',
                          email: 'email',
                          phoneNumber: '000-0000-0000',
                          date: DateTime(2024, 2, 1, 14, 30),
                        );
                        final service = ReservationService();
                        final data = await service.insertReservation(res);
                        print('data:$data');
                      } catch (e) {
                        print('エラーが発生しました: $e');
                      }
                    },
                    child: Text('予約'),
                  ),
                ],
              ),
            ),
          ),
          ref.watch(detailSelectStateProvider) ? const ReservationSelectWidget() : Container(),
          true ? const Loading() : Container(),
          // ref.watch(loadingStateProvider) ? const Loading() : Container(),
          ElevatedButton(
            onPressed: () {
              if (isShow) {
                ref.read(loadingStateProvider.notifier).stop();
              } else {
                ref.read(loadingStateProvider.notifier).start();
              }
            },
            child: Text(isShow ? 'hide' : 'show'),
          ),
        ],
      ),
    );
  }
}

class DayContent extends HookConsumerWidget {
  final DateTime day;
  final Color color;
  const DayContent(this.day, this.color, {super.key});

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
    }, [ref.watch(temporaryReservationDateProvider)]);

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
              border: isReserved.value ? Border.all(width: 2.0, color: Colors.green) : null,
              borderRadius: BorderRadius.circular(10.0),
              color: color,
              boxShadow: [
                BoxShadow(
                  color: isReserved.value ? Colors.green.withOpacity(0.5) : Colors.transparent,
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ]),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 2,
                child: isReserved.value
                    ? Image.asset('assets/images/reservedTooth.png',
                        width: containerSize.value.width * 0.6,
                        height: containerSize.value.width * 0.7,
                        fit: BoxFit.fill)
                    : Container(),
              ),
              Padding(
                padding: isReserved.value
                    ? const EdgeInsets.only(top: 0.0, left: 2.0)
                    : const EdgeInsets.only(top: 2.0, left: 4.0),
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

    String formatDate(DateTime date) {
      return "${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}";
    }

    final String formattedDate = tempoDay != null ? formatDate(tempoDay) : "";

    return Container(
        // width: 350,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.green[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('選択中の予約日時',
                      style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.normal, fontSize: 20)),
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 4.0),
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(formattedDate,
                            style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 24)),
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12.0),
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.green[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  //
                },
                child: Text('予約', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
          ],
        ));
  }
}
