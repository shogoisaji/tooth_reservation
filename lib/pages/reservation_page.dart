import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:tooth_reservation/animations/calender_scale_animation.dart';
import 'package:tooth_reservation/models/reservation.dart';
import 'package:tooth_reservation/services/reservation_service.dart';
import 'package:tooth_reservation/states/state.dart';
import 'package:tooth_reservation/theme/color_theme.dart';
import 'package:tooth_reservation/widgets/loading.dart';
import 'package:tooth_reservation/widgets/reservation_select_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReservationPage extends HookConsumerWidget {
  const ReservationPage({super.key});

  final double minWidth = 350;
  final double maxWidth = 500;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.of(context).size.width;
    final isDragging = useState<bool>(false);
    final reservationList = useState<List<Reservation>>([]);
    final ReservationService service = ReservationService();
    final _calenderWidth = MediaQuery.of(context).size.width < minWidth
        ? minWidth
        : MediaQuery.of(context).size.width > maxWidth
            ? maxWidth
            : MediaQuery.of(context).size.width;
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

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.8, 0.3),
          end: Alignment(0.3, 0.0),
          colors: [
            // Color(MyColor.mint1),
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
                        // border: Border.all(width: 2.0, color: Colors.green[300]!.withOpacity(0.5)),
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
                        // border: Border.all(width: 2.0, color: Colors.green[300]!.withOpacity(0.5)),
                      )),
                ),
                Center(
                  child: Container(
                    width: _calenderWidth,
                    // color: Colors.grey[100],
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.circleChevronLeft, color: Colors.green[900]),
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
                                },
                              ),
                            ],
                          ),
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
                                    ? Colors.white
                                    : Colors.red[100 * (count + 1) > 900 ? 900 : 100 * (count + 1)];
                                return index < getFirstWeekDay() ? Container() : DayContent(day!, color!);
                              }),
                        ),
                        const TemporaryDateWidget(),
                        const SizedBox(
                          width: 60,
                          height: 165,
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
                  right: MediaQuery.of(context).size.width * 0.5 - 50,
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
                  bottom: 140,
                  right: MediaQuery.of(context).size.width * 0.5 - 45,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(temporaryReservationDateProvider.notifier).selectDate(null);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
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
          ref.watch(detailSelectStateProvider) &&
                  !isDragging.value &&
                  ref.watch(temporaryReservationDateProvider) == null
              ? Positioned(
                  bottom: 60,
                  right: MediaQuery.of(context).size.width * 0.5 - 75,
                  child: IgnorePointer(
                      child: Lottie.asset(
                    'assets/lottie/pickUp.json',
                    width: 150,
                  )))
              : Container(),
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
    final w = MediaQuery.of(context).size.width;

    String formatDate(DateTime date) {
      return "${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}";
    }

    final String formattedDate = tempoDay != null ? formatDate(tempoDay) : "";

    return Container(
        // width: 350,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
              child: Column(
                children: [
                  Text('選択中の予約日時',
                      style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.normal, fontSize: 20)),
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
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
                        child: Center(
                          child: Text(formattedDate,
                              style: TextStyle(
                                  color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: w > 700 ? 24 : 20)),
                        )),
                  ),
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
                    return CustomDialog(tempoDay);
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.only(left: 12.0),
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: tempoDay != null ? Color(MyColor.green) : Colors.grey[500],
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
          onPressed: () async {
            Navigator.of(context).pop();
            try {
              final String? userId = ref.read(loggedInUserProvider)?.userId;
              final res = Reservation(
                id: 1,
                userId: userId,
                userName: 'test',
                email: 'email',
                phoneNumber: '000-0000-0000',
                date: date,
              );
              final service = ReservationService();
              final data = await service.insertReservation(res);
              ref.read(temporaryReservationDateProvider.notifier).selectDate(null);
              print('data:$data');
            } catch (e) {
              print('エラーが発生しました: $e');
            }
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
