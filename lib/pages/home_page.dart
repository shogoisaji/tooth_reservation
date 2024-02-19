import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:tooth_reservation/models/config.dart';
import 'package:tooth_reservation/models/reservation/reservation.dart';
import 'package:tooth_reservation/repositories/shared_preferences/shared_preferences_key.dart';
import 'package:tooth_reservation/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:tooth_reservation/routes/route_aware_event.dart';
import 'package:tooth_reservation/routes/route_obserber.dart';
import 'package:tooth_reservation/string.dart';
import 'package:tooth_reservation/theme/color_theme.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey reservationHistoryCardKey = GlobalKey();
    final _sharedPreferences = ref.watch(sharedPreferencesRepositoryProvider);
    final nextReservation = useState<String?>(null);
    final List<String>? reservationHistory = ['2023/2/21 14:30', '2024/2/20 10:30', '2025/2/18 14:30'];
    final w = MediaQuery.sizeOf(context).width;
    final reservationHistoryCardHeight = useState(200.0);

    // 画面遷移のイベントを取得
    final routeAware = useRouteAwareEvent(ref.watch(routeObserverProvider));

    // 画面遷移の際に予約情報を取得
    useEffect(() {
      final sharedString = _sharedPreferences.fetchCurrentReservation(SharedPreferencesKey.reservation);
      if (sharedString != null) {
        nextReservation.value = sharedString.toYMDHMString();
      }
      return null;
    }, [routeAware]);

    // 予約履歴、予約ページのheightを合わせるために予約履歴のheightを取得
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox renderBox = reservationHistoryCardKey.currentContext?.findRenderObject() as RenderBox;
        reservationHistoryCardHeight.value = renderBox.size.height;
      });
      return null;
    }, [reservationHistoryCardKey]);

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(w > Config.breakPoint ? 12.0 : 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: w > Config.breakPoint ? 24.0 : 12.0,
              ),
              _reservationStatusCard(nextReservation.value, w),
              SizedBox(
                height: w > Config.breakPoint ? 14.0 : 8,
              ),
              Row(children: [
                Expanded(
                    child: _reservationHistoryCard(reservationHistory, w,
                        reservationHistoryCardKey: reservationHistoryCardKey)),
                SizedBox(
                  width: w > Config.breakPoint ? 14.0 : 8,
                ),
                Expanded(child: _goToReservationPageButton(context, w, reservationHistoryCardHeight.value)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reservationStatusCard(String? nextReservation, double w) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(MyColor.mint4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '予約状況',
              style: TextStyle(
                color: const Color(MyColor.textBlack),
                fontSize: w > Config.breakPoint ? 32.0 : 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    nextReservation != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('予約日時',
                                  style: TextStyle(
                                    color: const Color(MyColor.textBlack),
                                    fontSize: w > Config.breakPoint ? 32.0 : 24.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(nextReservation,
                                  style: TextStyle(
                                    color: const Color(MyColor.textBlack),
                                    fontSize: w > Config.breakPoint ? 32.0 : 24.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          )
                        : Text('予約なし',
                            style: TextStyle(
                              color: const Color(MyColor.textBlack),
                              fontSize: w > Config.breakPoint ? 32.0 : 24.0,
                              fontWeight: FontWeight.bold,
                            )),
                  ],
                ))
          ],
        ));
  }

  Widget _reservationHistoryCard(List<String>? reservationHistory, double w, {Key? reservationHistoryCardKey}) {
    return Container(
        key: reservationHistoryCardKey,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(MyColor.mint4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '予約履歴',
              style: TextStyle(
                color: const Color(MyColor.textBlack),
                fontSize: w > Config.breakPoint ? 32.0 : 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    reservationHistory != null
                        ? Column(children: [
                            ...List.generate(
                              3,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(reservationHistory[index],
                                    style: TextStyle(
                                      color: const Color(MyColor.textBlack),
                                      fontSize: w > Config.breakPoint ? 24.0 : 18.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            )
                          ])
                        : Text('履歴なし',
                            style: TextStyle(
                              color: const Color(MyColor.textBlack),
                              fontSize: w > Config.breakPoint ? 32.0 : 24.0,
                              fontWeight: FontWeight.bold,
                            )),
                  ],
                ))
          ],
        ));
  }

  Widget _goToReservationPageButton(BuildContext context, double w, double widgetHeight) {
    return Container(
        width: double.infinity,
        height: widgetHeight,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(MyColor.mint4),
        ),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, 0.3),
              child: SizedBox(
                height: widgetHeight * 0.7,
                child: Lottie.asset(
                  'assets/lottie/hurt_tooth.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(MyColor.mint1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('予約ページへ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () {
                  context.go('/reservation');
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '予約',
                  style: TextStyle(
                    color: const Color(MyColor.textBlack),
                    fontSize: w > Config.breakPoint ? 32.0 : 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
