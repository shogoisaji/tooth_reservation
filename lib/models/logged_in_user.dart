class LoggedInUser {
  final String username;
  final String email;
  final String? phoneNumber;

  LoggedInUser({
    required this.username,
    required this.email,
    this.phoneNumber,
  });
}
