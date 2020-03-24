import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class FacebookService {
  dynamic name;
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  dynamic id;

  static FacebookService _singleton;

  factory FacebookService() {
    if (_singleton != null)
      return _singleton;
    else
      return _singleton = new FacebookService._internal();
  }

  FacebookService._internal();

  fromJson(Map<String, dynamic> json) {
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    id = json['id'];
  }

  final FacebookLogin _facebookSignIn = new FacebookLogin();
  Future<bool> handleSignIn() async {
    bool result = false;
    final FacebookLoginResult fbResult = await _facebookSignIn.logIn(['email']);
    switch (fbResult.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = fbResult.accessToken;
        final token = accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        final profile = json.decode(graphResponse.body);
        this.fromJson(profile);
        result = true;
        break;
      case FacebookLoginStatus.cancelledByUser:
      case FacebookLoginStatus.error:
        break;
    }
    return result;
  }

  Future<void> handleSignOut() async {
    await _facebookSignIn.logOut();
    _singleton = null;
  }
}
