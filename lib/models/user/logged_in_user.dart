import 'package:freezed_annotation/freezed_annotation.dart';

part 'logged_in_user.freezed.dart';
part 'logged_in_user.g.dart';

@freezed
class LoggedInUser with _$LoggedInUser {
  const factory LoggedInUser({
    required String userId,
    required String username,
    required String email,
    String? phoneNumber,
  }) = _LoggedInUser;

  factory LoggedInUser.fromJson(Map<String, dynamic> json) => _$LoggedInUserFromJson(json);
}
