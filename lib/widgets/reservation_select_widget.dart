import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tooth_reservation/states/state.dart';

class ReservationSelectWidget extends HookConsumerWidget {
  const ReservationSelectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final DateFormat format = DateFormat('yyyy.MM.dd');
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(detailSelectStateProvider.notifier).hide();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.withOpacity(0.6),
          ),
        ),
        Align(
          alignment: Alignment.center,
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
                  child: Text(format.format(ref.watch(selectedDateProvider)), style: const TextStyle(fontSize: 20)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(
                        ref.watch(businessHoursProvider).length,
                        (index) => ScheduleContent(
                            index: index,
                            w: (w - w / ref.watch(businessHoursProvider).length * 4) /
                                ref.watch(businessHoursProvider).length,
                            hour: index,
                            minuit: 0)),
                  ],
                )
              ],
            ),
          ),
        ),
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
    final animationController = useAnimationController(duration: const Duration(milliseconds: 200));
    final isHover = useState(false);
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return MouseRegion(
          onEnter: (_) {
            animationController.forward();
            isHover.value = true;
          },
          onExit: (_) {
            animationController.reverse();
            isHover.value = false;
          },
          child: Container(
            width: w * (1 + animationController.value * 4),
            height: 150,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.green),
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
            child: Column(
              children: [
                SizedBox(
                  // width: 500,
                  child: isHover.value
                      ? Text(
                          '${ref.watch(businessHoursProvider)[index]['hour']}:${ref.watch(businessHoursProvider)[index]['minuit'] == 0 ? '00' : ref.watch(businessHoursProvider)[index]['minuit']}',
                          style: TextStyle(fontSize: 16 * animationController.value),
                        )
                      : Text(
                          '${ref.watch(businessHoursProvider)[index]['hour']}\n ${ref.watch(businessHoursProvider)[index]['minuit'] == 0 ? '00' : ref.watch(businessHoursProvider)[index]['minuit']}',
                          style: TextStyle(fontSize: 10),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
