import 'package:apple_sign_in/apple_sign_in.dart';

class AppleService {
  static Future<bool> isAvaiable() async {
    var result = await AppleSignIn.isAvailable();
    return result;
  }

  static AppleIdCredential currentUser;
  static Future<bool> handleLogin() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    bool response = false;
    switch (result.status) {
      case AuthorizationStatus.authorized:
        currentUser = result.credential;
        response = true;
        break;

      case AuthorizationStatus.error:
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
    return response;
  }
}
