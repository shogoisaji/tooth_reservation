import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tooth_reservation/models/settings/business_hour_setting_data.dart';

part 'load_setting_data.g.dart';

@Riverpod(keepAlive: true)
class LoadSettingData extends _$LoadSettingData {
  @override
  BusinessHourSettingData? build() => null;

  Future<void> load() async {
    try {
      final String data = await rootBundle.loadString('assets/data/business_hour_data.json');
      final Map<String, dynamic> jsonResult = json.decode(data);
      final settingData = BusinessHourSettingData.fromJson(jsonResult);
      print("settingData loaded: $settingData");
      state = settingData;
    } catch (e) {
      print("error: $e");
    }
  }
}
