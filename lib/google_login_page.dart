import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleLoginPage extends StatefulWidget {
  @override
  _GoogleLoginPageState createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/gmail.send'],
    clientId: '528888226435-qp8r73od0f4tqd20984kgluc16mbvvaj.apps.googleusercontent.com', // Add this for web support
  );

  Future<void> _handleLogin() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication auth = await account!.authentication;

      final accessToken = auth.accessToken;
      final idToken = auth.idToken;

      // Send to backend
      final response = await http.post(
        Uri.parse('https://1s09gghd-5000.inc1.devtunnels.ms/save-google-user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": account.email,
          "name": account.displayName,
          "access_token": accessToken,
          "refresh_token": null, // Not available directly
          "id_token": idToken,
        }),
      );

      print("Backend response: ${response.body}");
    } catch (e) {
      print("Login error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Login")),
      body: Center(
        child: ElevatedButton(
          child: Text("Login with Google"),
          onPressed: _handleLogin,
        ),
      ),
    );
  }
}
