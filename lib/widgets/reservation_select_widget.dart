import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tooth_reservation/animations/calender_scale_animation.dart';
import 'package:tooth_reservation/states/state.dart';

class ReservationSelectWidget extends HookConsumerWidget {
  const ReservationSelectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScale = useState(false);
    final scaleIndex = useState<int?>(null);
    const durationValue = 300;
    final animationController = useAnimationController(duration: const Duration(milliseconds: durationValue));
    final animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final DateFormat format = DateFormat('yyyy.MM.dd');

    useEffect(() {
      if (ref.watch(detailSelectStateProvider)) {
        animationController.forward();
      } else {
        animationController.reverse();
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
                    height: h * 0.4,
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(format.format(ref.watch(selectedDateProvider)),
                              style: const TextStyle(fontSize: 20)),
                        ),
                        Container(
                          width: w,
                          height: 250,
                          child: Stack(
                            children: [
                              ...List.generate(ref.watch(businessHoursProvider).length, (index) {
                                final int firstHour = ref.watch(businessHoursProvider)[0]['hour'] ?? 0;
                                final double leftPosition =
                                    ((ref.watch(businessHoursProvider)[index]['hour'] ?? 0) - firstHour).toDouble() *
                                        38;
                                final double topPosition =
                                    (ref.watch(businessHoursProvider)[index]['minuit'] ?? 0).toDouble() * 3 + 50;
                                print('$topPosition $leftPosition');
                                return Positioned(
                                    left: leftPosition,
                                    top: topPosition,
                                    child: ScheduleContent(index: index, w: 40, hour: index, minuit: 0));
                              }),
                            ],
                          ),
                        ),
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
  final int hour;
  final int minuit;
  const ScheduleContent({super.key, required this.index, required this.w, required this.hour, required this.minuit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(duration: const Duration(milliseconds: 700));
    final animation = CurvedAnimation(parent: animationController, curve: Curves.elasticOut);
    final isScale = useState(false);

    useEffect(() {
      if (isScale.value) {
        animationController.forward();
      } else {
        animationController.reverse(from: 0.3);
      }
      return;
    }, [isScale.value]);

    return AnimatedBuilder(
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
                  isScale.value = true;
                });
              } else {
                // exit
                Future.microtask(() {
                  isScale.value = false;
                });
              }
              return Transform.translate(
                offset: Offset(-w / 0.8 * animation.value, -w / 0.8 * animation.value),
                child: Container(
                  width: w * (1 + animation.value * 1.5),
                  height: w * (1 + animation.value * 1.5),
                  alignment: Alignment(0, -animation.value * 0.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    shape: BoxShape.circle,
                    color: Colors.green[200],
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
                    '${ref.watch(businessHoursProvider)[index]['hour']}:${ref.watch(businessHoursProvider)[index]['minuit'] == 0 ? '00' : ref.watch(businessHoursProvider)[index]['minuit']}',
                    style: TextStyle(fontSize: 12 * (1 + animation.value)),
                  ),
                ),
              );
            },
          );
        });
  }
}
