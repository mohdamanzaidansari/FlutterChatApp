import 'dart:io';

import 'package:chatApp/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "auth-screen";

  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  void _submitAuthFormCallback(
    BuildContext context,
    String email,
    String password,
    String username,
    bool isSignupMode,
    File userImage,
  ) async {
    AuthResult authResult;
    if (userImage == null) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      if (isSignupMode) {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(authResult.user.uid + '.jpg');

      await ref.putFile(userImage).onComplete;
      final url = await ref.getDownloadURL();

      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({
        'username': username,
        'email': email,
        'image_url': url,
      });
    } on PlatformException catch (error) {
      setState(() {
        _isLoading = false;
      });
      String message;
      error.message != null
          ? message = error.message
          : message = 'An error occured, please check your credentials!';

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitAuthFormCallback: _submitAuthFormCallback,
        isLoading: _isLoading,
      ),
    );
  }
}
