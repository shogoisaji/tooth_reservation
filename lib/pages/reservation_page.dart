import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tooth_reservation/animations/calender_scale_animation.dart';
import 'package:tooth_reservation/states/state.dart';

class ReservationPage extends HookConsumerWidget {
  const ReservationPage({super.key});

  final double minWidth = 400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Center(
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
                  children: [
                    ...List.generate(
                      7,
                      (index) => Container(
                        alignment: Alignment.center,
                        width: _calenderWidth / 7,
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Colors.blue[100]),
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
                      itemCount: daysListGenerate(selectedMonth.value["year"]!, selectedMonth.value["month"]!).length +
                          getFirstWeekDay(),
                      itemBuilder: (BuildContext context, int index) {
                        return index < getFirstWeekDay()
                            ? Container()
                            : DayContent(daysListGenerate(selectedMonth.value["year"]!, selectedMonth.value["month"]!)[
                                index - getFirstWeekDay()]);
                      }),
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
                  },
                  child: Text('reset'),
                ),
              ],
            ),
            ref.watch(detailSelectStateProvider) ? Center(child: DetailSelect()) : Container(),
          ],
        ),
      ),
    );
  }
}

class DayContent extends HookConsumerWidget {
  final DateTime day;
  const DayContent(this.day, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScale = useState<bool>(false);

    return CalenderScaleAnimation(
      isScale: isScale.value,
      child: DragTarget(
          //   onAccept: (data) {
          //   isScale.value = true;
          //   Future.delayed(const Duration(milliseconds: 200), () {
          //     isScale.value = false;
          //   });
          // },
          builder: (context, candidateData, rejectedData) {
        if (candidateData.isNotEmpty) {
          Future.microtask(() {
            isScale.value = true;
          });
        } else {
          Future.microtask(() {
            isScale.value = false;
          });
        }

        return Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.red[100]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(day.day.toString()),
          ),
        );
      }),
    );
  }
}

class DetailSelect extends HookConsumerWidget {
  const DetailSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      width: w,
      height: 200,
      color: Colors.blue.withOpacity(0.5),
    );
  }
}
