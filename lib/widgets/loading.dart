import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:tooth_reservation/states/app_state.dart';
import 'package:tooth_reservation/theme/color_theme.dart';

class Loading extends HookConsumerWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(duration: const Duration(milliseconds: 1500));
    final opacityController = useAnimationController(duration: const Duration(milliseconds: 500));
    final w = MediaQuery.sizeOf(context).width;
    final isLoading = ref.watch(loadingStateProvider);
    useEffect(() {
      if (isLoading) {
        animationController.repeat();
        opacityController.forward(from: 0.9);
      } else {
        opacityController.reverse();
        if (opacityController.value == 0.0) {
          animationController.stop();
        }
      }
      return;
    }, [ref.watch(loadingStateProvider)]);

    return IgnorePointer(
      ignoring: !isLoading,
      child: AnimatedBuilder(
        animation: opacityController,
        builder: (context, child) => Opacity(
            opacity: opacityController.value,
            child: Container(
              alignment: const Alignment(-0.08, -0.1),
              width: w,
              height: double.infinity,
              color: const Color(MyColor.mint4),
              child: Lottie.asset(
                'assets/lottie/tooth_wash.json',
                controller: animationController,
                width: 150,
              ),
            )),
      ),
    );
  }
}
