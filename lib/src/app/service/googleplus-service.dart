import 'package:google_sign_in/google_sign_in.dart';

class GooglePlusService {
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'profile',
    ],
  );
  static GoogleSignInAccount currentUser;
  static Future<bool> handleSignIn() async {
    bool result = false;
    try {
      return _googleSignIn.signIn().then((onValue) {
        if (onValue != null) {
          currentUser = onValue;
          print('urlPhoto ${GooglePlusService.currentUser.photoUrl}');
          result = true;
        } else {
          currentUser = null;
        }
        return result;
      });
    } catch (error) {
      return result;
    }
  }

  static Future<void> handleSignOut() async {
    if (currentUser != null) {
      await _googleSignIn.disconnect();
      currentUser = null;
    }
  }
}
