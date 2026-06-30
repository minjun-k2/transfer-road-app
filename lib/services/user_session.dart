class UserSession {
  static int? userId;
  static String? username;
  static String? name;
  static String? email;

  static void login(int id, String uname, {String? userName, String? userEmail}) {
    userId = id;
    username = uname;
    name = userName;
    email = userEmail;
  }

  static void logout() {
    userId = null;
    username = null;
    name = null;
    email = null;
  }

  static bool get isLoggedIn => userId != null;
}