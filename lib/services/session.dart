class Session {
  static int? userId;
  static String? role;
  static String? fullName;

  static void clear() {
    userId = null;
    role = null;
    fullName = null;
  }
}