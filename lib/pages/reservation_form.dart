import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tooth_reservation/models/reservation/reservation.dart';
import 'package:tooth_reservation/repositories/shared_preferences/shared_preferences_key.dart';
import 'package:tooth_reservation/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_repository.dart';
import 'package:tooth_reservation/states/app_state.dart';
import 'package:tooth_reservation/theme/color_theme.dart';
import 'package:tooth_reservation/widgets/loading.dart';

class ReservationFormPage extends HookConsumerWidget {
  const ReservationFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _sharedPreferences = ref.watch(sharedPreferencesRepositoryProvider);
    final _emailController = useTextEditingController();
    final _userNameController = useTextEditingController();
    final _phoneNumberController = useTextEditingController();
    final DateTime? selectTime = ref.watch(temporaryReservationDateProvider);
    final _client = ref.read(supabaseRepositoryProvider);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(MyColor.mint2),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        requiredLabel(),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: '名前',
                            ),
                            controller: _userNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '名前は必須です。';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        requiredLabel(),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'メール',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'メールは必須です。';
                              }
                              return null;
                            },
                            controller: _emailController,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        optionalLabel(),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: '電話番号',
                            ),
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: selectTime != null
                          ? Text(
                              '予約日時: ${selectTime.year}/${selectTime.month}/${selectTime.day} ${selectTime.hour}:${selectTime.minute == 0 ? '00' : selectTime.minute}',
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.green[900]),
                            )
                          : Container(),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 3.0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '予約する',
                            style: TextStyle(fontSize: 20.0, color: Colors.green[700]!, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (selectTime == null) {
                              throw Exception('予約日時が選択されていません');
                            }
                            final res = Reservation(
                              id: null,
                              userId: null,
                              userName: _userNameController.text,
                              email: _emailController.text,
                              phoneNumber: _phoneNumberController.text,
                              reservationDate: selectTime,
                            );
                            try {
                              ref.read(loadingStateProvider.notifier).show();
                              final data = await _client.insertReservation(res);
                              _sharedPreferences.saveCurrentReservation(
                                  SharedPreferencesKey.reservation, res.reservationDate.toIso8601String());
                              print('insert result:$data');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(milliseconds: 1000),
                                    content: Center(
                                        child: Text('予約が完了しました',
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold))),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              }
                              Future.delayed(const Duration(milliseconds: 1000), () {
                                ref.read(temporaryReservationDateProvider.notifier).selectDate(null);
                                ref.read(loadingStateProvider.notifier).hide();
                                context.go('/');
                              });
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('予約に失敗しました: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          const Loading()
        ],
      ),
    );
  }
}

Widget requiredLabel() {
  return Container(
    margin: const EdgeInsets.only(top: 10.0),
    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: Colors.red[400],
      borderRadius: BorderRadius.circular(5),
    ),
    child: const Center(
      child: Text(
        '必須',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ),
  );
}

Widget optionalLabel() {
  return Container(
    margin: const EdgeInsets.only(top: 10.0),
    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: Colors.grey[600],
      borderRadius: BorderRadius.circular(5),
    ),
    child: const Center(
      child: Text(
        '任意',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ),
  );
}
