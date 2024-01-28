class LoggedInUser {
  final String? userId;
  final String username;
  final String email;
  final String? phoneNumber;

  LoggedInUser({
    this.userId,
    required this.username,
    required this.email,
    this.phoneNumber,
  });
}
