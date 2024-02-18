extension StringExtension on String {
  // "2023-04-15 00:00:00.000" -> "2023/04/15 00:00"
  String toYMDHMString() {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}$');
    if (!regex.hasMatch(this)) {
      throw FormatException("対象の文字列はDateTimeを文字列に変換した形式である必要があります: ${this}");
    }
    final splitString = toString().split(' ');
    final ymd = splitString[0].split('-');
    final hm = splitString[1].split(':');
    return "${ymd[0]}/${ymd[1]}/${ymd[2]} ${hm[0]}:${hm[1] == '0' ? '00' : hm[1]}";
  }

  // "2023-04-15 00:00:00.000" -> "2023.04.15"
  String toYMDString() {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}$');
    if (!regex.hasMatch(this)) {
      throw FormatException("対象の文字列はDateTimeを文字列に変換した形式である必要があります: ${this}");
    }
    final splitString = toString().split(' ');
    final ymd = splitString[0].split('-');
    return "${ymd[0]}.${ymd[1]}.${ymd[2]}";
  }
}
