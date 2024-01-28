import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tooth_reservation/animations/calender_scale_animation.dart';
import 'package:tooth_reservation/models/reservation.dart';
import 'package:tooth_reservation/services/reservation_service.dart';
import 'package:tooth_reservation/states/state.dart';
import 'package:intl/intl.dart';
import 'package:tooth_reservation/widgets/reservation_select_widget.dart';

class ReservationPage extends HookConsumerWidget {
  const ReservationPage({super.key});

  final double minWidth = 400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: Stack(
                children: [
                  Column(
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
                              // return index < getFirstWeekDay()
                              //     ? Container()
                              //     : DayContent(daysListGenerate(selectedMonth.value["year"]!, selectedMonth.value["month"]!)[
                              //         index - getFirstWeekDay()]);
                              final DateTime? day = index < getFirstWeekDay()
                                  ? null
                                  : daysListGenerate(selectedMonth.value["year"]!, selectedMonth.value["month"]!)[
                                      index - getFirstWeekDay()];
                              //   // 時間を無視して日付のみ
                              //   final convertDate = DateTime(
                              //     reservation.date.year,
                              //     reservation.date.month,
                              //     reservation.date.day,
                              //   );
                              //   return convertDate == day;
                              // });
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
                      StreamBuilder(
                        stream: service.getReservationListAllStream(),
                        builder: (context, AsyncSnapshot<List<Reservation>> snapshot) {
                          if (snapshot.hasError) {
                            print('エラーが発生しました: ${snapshot.error}');
                            return Text('エラーが発生しました: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return Column(
                              children: [
                                ...snapshot.data!.take(3).map((e) {
                                  DateFormat format = DateFormat('yyyy-MM-dd HH:mm');
                                  return Container(
                                      padding: const EdgeInsets.all(4.0), child: Text(format.format(e.date)));
                                }).toList(),
                              ],
                            );
                          } else {
                            return SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                      ),
                      !isDragCompleted.value
                          ? Draggable(
                              data: 1,
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.blue,
                              ),
                              feedback: Container(
                                width: 50,
                                height: 50,
                                color: Colors.blue,
                              ),
                              childWhenDragging: Container(
                                width: 50,
                                height: 50,
                                color: Colors.transparent,
                              ),
                              onDragCompleted: () {
                                print('drag completed');
                                isDragCompleted.value = true;
                              },
                            )
                          : Container(),
                      ElevatedButton(
                        onPressed: () {
                          isDragCompleted.value = false;
                          ref.read(detailSelectStateProvider.notifier).hide();
                        },
                        child: Text('reset'),
                      ),
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
                              date: DateTime(2024, 1, 29, 11, 30),
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
                ],
              ),
            ),
          ),
          ref.watch(detailSelectStateProvider) ? ReservationSelectWidget() : Container(),
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
    final h = MediaQuery.of(context).size.height;
    final isScale = useState<bool>(false);
    return CalenderScaleAnimation(
      isScale: isScale.value,
      child: GestureDetector(
        onTap: () {
          ref.read(selectedDateProvider.notifier).selectDate(day);
          ref.read(detailSelectStateProvider.notifier).show();
          // showModalBottomSheet(
          //   isScrollControlled: true,
          //   enableDrag: false,
          //   barrierColor: Colors.white.withOpacity(0.7),
          //   backgroundColor: Colors.transparent,
          //   context: context,
          //   builder: (context) {
          //     return Container(
          //       height: h * 0.7,
          //       color: Colors.blue[200],
          //     );
          //   },
          // );
        },
        child: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: color),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(day.day.toString()),
          ),
        ),
      ),
      // DragTarget(
      //     //   onAccept: (data) {
      //     //   isScale.value = true;
      //     //   Future.delayed(const Duration(milliseconds: 200), () {
      //     //     isScale.value = false;
      //     //   });
      //     // },
      //     builder: (context, candidateData, rejectedData) {
      //   if (candidateData.isNotEmpty) {
      //     // hover
      //     Future.microtask(() {
      //       isScale.value = true;
      //     });
      //   } else {
      //     // exit
      //     Future.microtask(() {
      //       isScale.value = false;
      //     });
      //   }

      //   return Container(
      //     margin: const EdgeInsets.all(4.0),
      //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.red[100]),
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Text(day.day.toString()),
      //     ),
      //   );
      // }),
    );
  }
}
