import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
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
    final isDragging = useState<bool>(false);
    final reservationList = useState<List<Reservation>>([]);
    final ReservationService service = ReservationService();
    final _calenderWidth =
        MediaQuery.of(context).size.width * 0.5 < minWidth ? minWidth : MediaQuery.of(context).size.width * 0.5;
    final selectedMonth = useState<Map<String, int>>({"year": DateTime.now().year, "month": DateTime.now().month});
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(loadingStateProvider.notifier).show();
      });
      final StreamSubscription<List<Reservation>> stream = service.getReservationListAllStream().listen((event) {
        print('event: ${event.length}');
        reservationList.value = event;
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(loadingStateProvider.notifier).hide();
        });
      });
      return () {
        stream.cancel();
      };
    }, []);

    return Stack(
      children: [
        SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: _calenderWidth,
                  // color: Colors.grey[100],
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
                                    BoxDecoration(borderRadius: BorderRadius.circular(6.0), color: Colors.blue[300]),
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
                            physics: const NeverScrollableScrollPhysics(),
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
                                  ? Colors.blue[100]
                                  : Colors.red[100 * (count + 1) > 900 ? 900 : 100 * (count + 1)];
                              return index < getFirstWeekDay() ? Container() : DayContent(day!, color!);
                            }),
                      ),
                      const TemporaryDateWidget(),
                      const SizedBox(
                        width: 60,
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),
              ref.watch(detailSelectStateProvider) ? const ReservationSelectWidget() : Container(),
              true ? const Loading() : Container(),
              // ref.watch(loadingStateProvider) ? const Loading() : Container(),
              // Positioned(
              //   bottom: 200,
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       try {
              //         final String? userId = ref.read(loggedInUserProvider)?.userId;
              //         final res = Reservation(
              //           id: 1,
              //           userId: userId,
              //           userName: 'test',
              //           email: 'email',
              //           phoneNumber: '000-0000-0000',
              //           date: DateTime(2024, 2, 8, 13, 00),
              //         );
              //         final service = ReservationService();
              //         final data = await service.insertReservation(res);
              //         print('data:$data');
              //       } catch (e) {
              //         print('エラーが発生しました: $e');
              //       }
              //     },
              //     child: Text('予約'),
              //   ),
              // ),
            ],
          ),
        ),
        ref.watch(temporaryReservationDateProvider) == null
            ? Positioned(
                bottom: ref.watch(detailSelectStateProvider) ? 65 : 45,
                right: MediaQuery.of(context).size.width * 0.5 - 48,
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
                        onDragCompleted: () {
                          print('drag completed');
                        },
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
            : Positioned(
                bottom: 120,
                right: MediaQuery.of(context).size.width * 0.5 - 45,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(temporaryReservationDateProvider.notifier).selectDate(null);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.green, width: 3.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  ),
                  child: Text('Reset',
                      style: TextStyle(color: Colors.green[700], fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
        Positioned(
          bottom: -10,
          child: IgnorePointer(
              child:
                  Image.asset('assets/images/gum.png', width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth)),
        ),
        ref.watch(detailSelectStateProvider) && !isDragging.value && ref.watch(temporaryReservationDateProvider) == null
            ? Positioned(
                bottom: 120,
                right: MediaQuery.of(context).size.width * 0.5 - 10,
                child: IgnorePointer(
                    child: Lottie.asset(
                  'assets/lottie/drag.json',
                  width: 150,
                )))
            : Container(),
      ],
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
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.green[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('選択中の予約日時',
                      style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.normal, fontSize: 20)),
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
            InkWell(
              onTap: () {
                if (tempoDay == null) {
                  return;
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(tempoDay!);
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.only(left: 12.0),
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: tempoDay != null ? Colors.green[600] : Colors.grey[500],
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
    String formatDate(DateTime date) {
      return "${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}";
    }

    final String formattedDate = formatDate(date);
    return AlertDialog(
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
          onPressed: () {
            Navigator.of(context).pop();
            print('予約');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
          ),
          child: const Text('予約する', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ],
    );
  }
}
