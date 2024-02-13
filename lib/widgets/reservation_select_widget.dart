import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tooth_reservation/models/reservation/reservation.dart';
import 'package:tooth_reservation/models/reservation/reservation_list.dart';
import 'package:tooth_reservation/models/settings/business_hour_settings.dart';
import 'package:tooth_reservation/states/app_state.dart';
import 'package:tooth_reservation/theme/color_theme.dart';

class ReservationSelectWidget extends HookConsumerWidget {
  const ReservationSelectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const upperOffset = 50.0;
    const lowerOffset = 25.0;
    const durationValue = 300;
    final animationController = useAnimationController(duration: const Duration(milliseconds: durationValue));
    final animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    final w = MediaQuery.sizeOf(context).width;
    final DateFormat format = DateFormat('yyyy.MM.dd');
    final selectedDate = ref.watch(selectedDateProvider);
    final availableTimes = ref.watch(businessHourSettingsProvider).getReservationAvailableTimes();
    final availableTimesInterval = ref.watch(businessHourSettingsProvider).reservationMinuteInterval;

    final int rowCount = ref.watch(businessHourSettingsProvider).hourCount;
    final offset = w > 800 ? w / 2 : 30;
    double contentWidth = (w - offset) / rowCount;

    bool checkExistReservation(TimeOfDay time) {
      DateTime convertDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, time.hour, time.minute);
      final List<Reservation>? reservedList = ref.watch(reservationListProvider);
      if (reservedList == null) {
        return false;
      }
      for (final reservation in reservedList) {
        if (reservation.reservationDate == convertDate) {
          return true;
        }
      }
      return false;
    }

    useEffect(() {
      if (ref.watch(detailSelectStateProvider)) {
        animationController.forward(from: 0.0);
      } else {
        animationController.reverse(from: 0.0);
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
          alignment: const Alignment(0, -0.4),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Opacity(
                opacity: animation.value < 0.4 ? 0 : animation.value,
                child: Transform.scale(
                  scaleY: animation.value,
                  child: Container(
                    width: w,
                    height: upperOffset + lowerOffset + contentWidth * (60 / availableTimesInterval),
                    decoration: BoxDecoration(
                      color: const Color(MyColor.mint2),
                      border: Border(
                        top: BorderSide(color: Colors.green[700]!.withOpacity(0.5), width: 3),
                        bottom: BorderSide(color: Colors.green[700]!.withOpacity(0.5), width: 3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 3,
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
                            child: Text(format.format(selectedDate),
                                style: TextStyle(color: Colors.green[800]!, fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        ...List.generate(availableTimes.length, (index) {
                          final bool isReserved = checkExistReservation(availableTimes[index]);
                          final int firstHour = availableTimes[0].hour;
                          final double leftPosition =
                              ((availableTimes[index].hour) - firstHour).toDouble() * contentWidth + offset / 2;
                          final double topPosition =
                              (availableTimes[index].minute).toDouble() / availableTimesInterval * contentWidth +
                                  upperOffset;
                          return Positioned(
                              left: leftPosition,
                              top: topPosition,
                              child: ScheduleTimeContent(
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
      ],
    );
  }
}

class ScheduleTimeContent extends HookConsumerWidget {
  final int index;
  final double w;
  final bool isReserved;
  const ScheduleTimeContent({
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
    final availableTimes = ref.watch(businessHourSettingsProvider).getReservationAvailableTimes();

    void selectCheck() {
      final DateTime? selectedDate = ref.watch(temporaryReservationDateProvider);
      final DateTime reservationDateTime = DateTime(
          ref.watch(selectedDateProvider).year,
          ref.watch(selectedDateProvider).month,
          ref.watch(selectedDateProvider).day,
          availableTimes[index].hour,
          availableTimes[index].minute);
      print('selectedDate:$selectedDate');
      if (selectedDate == null) {
        isSelected.value = false;
        return;
      }
      if (selectedDate == reservationDateTime) {
        isSelected.value = true;
        return;
      }
      isSelected.value = false;
    }

    useEffect(() {
      if (ref.watch(temporaryReservationDateProvider) != null) {
        selectCheck();
      } else {
        isSelected.value = false;
      }
      return;
    }, [ref.watch(temporaryReservationDateProvider)]);

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
              ref.read(temporaryReservationDateProvider.notifier).selectDate(DateTime(
                  ref.watch(selectedDateProvider).year,
                  ref.watch(selectedDateProvider).month,
                  ref.watch(selectedDateProvider).day,
                  availableTimes[index].hour,
                  availableTimes[index].minute));
              selectCheck();
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
                child: Transform.scale(
                  scale: isSelected.value ? 1.2 : 1.0,
                  child: Container(
                    width: w * (1 + animation.value * 1.5),
                    height: w * (1 + animation.value * 2.2),
                    alignment: Alignment(0, -animation.value * 0.6),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: isReserved
                              ? Colors.red
                              : isSelected.value
                                  ? Colors.blue
                                  : Colors.green[300]!),
                      shape: BoxShape.circle,
                      color: isReserved
                          ? Colors.red[200]
                          : isSelected.value
                              ? Colors.blue[300]
                              : Color(MyColor.mint4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      '${availableTimes[index].hour}:${availableTimes[index].minute == 0 ? '00' : availableTimes[index].minute}',
                      style: TextStyle(fontSize: 12 * (1 + animation.value * 0.8)),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
