import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    const durationValue = 300;
    final animationController = useAnimationController(duration: const Duration(milliseconds: durationValue));
    final animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final DateFormat format = DateFormat('yyyy.MM.dd');
    final selectedDate = ref.watch(selectedDateProvider);

    bool checkExistReservation(DateTime time) {
      DateTime convertDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, time.hour, time.minute);
      final List<Reservation>? reservedList = ref.watch(selectedReservationListDataProvider);
      if (reservedList == null) {
        return false;
      }
      for (final reservation in reservedList) {
        if (reservation.date == convertDate) {
          return true;
        }
      }
      return false;
    }

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
        animationController.forward(from: 0.0);
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
                          final bool isReserved = checkExistReservation(ref.watch(businessHoursProvider)[index]);
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
                              child: ScheduleContent(
                                  index: index, w: contentWidth > 50 ? 50 : contentWidth, isReserved: isReserved));
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
          alignment: Alignment(0, 0.3),
          child: Draggable(
            data: 1,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green[300],
                shape: BoxShape.circle,
              ),
            ),
            feedback: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green[300],
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
  final bool isReserved;
  const ScheduleContent({
    super.key,
    required this.index,
    required this.w,
    required this.isReserved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(duration: const Duration(milliseconds: 700));
    final animation = CurvedAnimation(parent: animationController, curve: Curves.elasticOut);
    final isScaleUp = useState(false);
    final isSelected = useState(false);

    // 初回mount時は無視する
    final previousIsScaleUp = useState<bool>(isScaleUp.value);
    useEffect(() {
      if (previousIsScaleUp.value != isScaleUp.value) {
        if (isScaleUp.value) {
          animationController.forward();
          HapticFeedback.lightImpact();
        } else {
          animationController.reverse(from: 0.3);
        }
        previousIsScaleUp.value = isScaleUp.value;
      }
      return;
    }, [isScaleUp.value]);

    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return DragTarget(
            onAccept: (data) {
              isSelected.value = true;
              print(data);
            },
            builder: (context, candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {
                if (!isReserved) {
                  // hover
                  Future.microtask(() {
                    isScaleUp.value = true;
                  });
                }
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
                  alignment: Alignment(0, -animation.value * 0.55),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isReserved
                            ? Colors.red
                            : isSelected.value
                                ? Colors.green
                                : Colors.blue),
                    shape: BoxShape.circle,
                    color: isReserved
                        ? Colors.red[200]
                        : isSelected.value
                            ? Colors.green[300]
                            : Colors.blue[100],
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
        });
  }
}
