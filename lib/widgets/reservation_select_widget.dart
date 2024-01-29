import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tooth_reservation/models/reservation.dart';
import 'package:tooth_reservation/services/reservation_service.dart';
import 'package:tooth_reservation/states/state.dart';

class ReservationSelectWidget extends HookConsumerWidget {
  const ReservationSelectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const durationValue = 400;
    final animationController = useAnimationController(duration: const Duration(milliseconds: durationValue));
    final animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final DateFormat format = DateFormat('yyyy.MM.dd');
    final selectedDate = ref.watch(selectedDateProvider);

    int hourCount() {
      int count = 0;
      int current = 0;
      for (int i = 0; i < ref.watch(businessHoursProvider).length; i++) {
        if (ref.watch(businessHoursProvider)[i].hour != current) {
          count++;
          current = ref.watch(businessHoursProvider)[i].hour;
        }
      }
      return count;
    }

    useEffect(() {
      if (ref.watch(detailSelectStateProvider)) {
        animationController.forward(from: 0.5);
      } else {
        animationController.reverse(from: 0.5);
      }
      return;
    }, [ref.watch(detailSelectStateProvider)]);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            animationController.reverse();
            Future.delayed(const Duration(milliseconds: durationValue), () {
              ref.read(detailSelectStateProvider.notifier).hide();
            });
          },
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Opacity(
              opacity: animation.value,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.4 * animation.value),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.5),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Opacity(
                opacity: animation.value,
                child: Transform.scale(
                  scale: animation.value,
                  child: Container(
                    width: w,
                    height: w * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(format.format(selectedDate), style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                        ...List.generate(ref.watch(businessHoursProvider).length, (index) {
                          int rowCount = hourCount();
                          const offset = 30;
                          double contentWidth = (w - offset) / rowCount;
                          final int firstHour = ref.watch(businessHoursProvider)[0].hour;
                          final double leftPosition =
                              ((ref.watch(businessHoursProvider)[index].hour) - firstHour).toDouble() * contentWidth +
                                  offset / 2;
                          final double topPosition =
                              (ref.watch(businessHoursProvider)[index].minute).toDouble() * 3 + 60;
                          return Positioned(
                              left: leftPosition,
                              top: topPosition,
                              child: ScheduleContent(index: index, w: contentWidth > 50 ? 50 : contentWidth));
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Draggable(
            data: 1,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            feedback: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            childWhenDragging: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
            onDragCompleted: () {
              print('drag completed');
            },
          ),
        )
      ],
    );
  }
}

class ScheduleContent extends HookConsumerWidget {
  final int index;
  final double w;
  const ScheduleContent({super.key, required this.index, required this.w});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReservationService service = ReservationService();
    final random = math.Random();
    final randomList = useState([]);
    final animationController = useAnimationController(duration: const Duration(milliseconds: 700));
    final randomAnimationController = useAnimationController(
        initialValue: random.nextDouble(), duration: Duration(milliseconds: (100 * random.nextInt(10)) + 1000));
    final randomAnimation = CurvedAnimation(parent: randomAnimationController, curve: Curves.easeInOut);
    final animation = CurvedAnimation(parent: animationController, curve: Curves.elasticOut);
    final isScaleUp = useState(false);
    final reservedList = useState<List<Reservation>>([]);
    final selectedDate = ref.watch(selectedDateProvider);

    Future<bool> fetchReservationList() async {
      final businessHours = ref.watch(businessHoursProvider)[index];
      final DateTime date =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day, businessHours.hour, businessHours.minute);
      reservedList.value = await service.getReservationList(selectedDate);
      for (final reservation in reservedList.value) {
        if (reservation.date == date) {
          // isReservation.value = true;
          print('true');
          return true;
        }
      }
      // isReservation.value = false;
      return false;
    }

    void setRandomList() {
      randomList.value = [];
      for (int i = 0; i < 50; i++) {
        randomList.value.add(3 * random.nextDouble());
      }
    }

    useEffect(() {
      // fetchReservationList();
      setRandomList();
      randomAnimationController.repeat(reverse: true);
      if (isScaleUp.value) {
        animationController.forward();
      } else {
        animationController.reverse(from: 0.3);
      }
      return;
    }, [isScaleUp.value]);

    return AnimatedBuilder(
        animation: randomAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(randomList.value[index] * randomAnimation.value, 3 * randomAnimation.value),
            child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return DragTarget(
                    onAccept: (data) {
                      print(data);
                    },
                    builder: (context, candidateData, rejectedData) {
                      if (candidateData.isNotEmpty) {
                        // hover
                        Future.microtask(() {
                          isScaleUp.value = true;
                        });
                      } else {
                        // exit
                        Future.microtask(() {
                          isScaleUp.value = false;
                        });
                      }
                      return Transform.translate(
                        offset: Offset(-w / 1.0 * animation.value, -w / 0.8 * animation.value),
                        child: Container(
                          width: w * (1 + animation.value * 1.5),
                          height: w * (1 + animation.value * 2.2),
                          alignment: Alignment(0, -animation.value * 0.5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            shape: BoxShape.circle,
                            color: Colors.green[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Text(
                            '${ref.watch(businessHoursProvider)[index].hour}:${ref.watch(businessHoursProvider)[index].minute == 0 ? '00' : ref.watch(businessHoursProvider)[index].minute}',
                            style: TextStyle(fontSize: 12 * (1 + animation.value * 0.8)),
                          ),
                        ),
                      );
                    },
                  );
                }),
          );
        });
  }
}
