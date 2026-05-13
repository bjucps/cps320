class AppUser {
  final String userName;
  final String userEmail;
  final List<String> favoriteEventIds;

  AppUser({
    required this.userName,
    required this.userEmail,
    required this.favoriteEventIds,
  });
}
