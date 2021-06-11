import 'dart:io';

import 'package:chatApp/widgets/auth/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function submitAuthFormCallback;
  final bool isLoading;

  const AuthForm({
    Key key,
    this.submitAuthFormCallback,
    this.isLoading,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username;
  String _password;
  String _email;
  File _userImageFile;
  bool _isSignupMode = false;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (_userImageFile == null && _isSignupMode) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
    if (isValid) {
      widget.submitAuthFormCallback(
        context,
        _email,
        _password,
        _username,
        _isSignupMode,
        _userImageFile,
      );
    }
  }

  void _pickImageCallback(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isSignupMode)
                    UserImagePicker(
                      picImageCallback: _pickImageCallback,
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  if (_isSignupMode)
                    TextFormField(
                      key: ValueKey('email'),
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Username must be at least 4 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _username = value;
                      },
                    ),
                  TextFormField(
                      key: ValueKey('password'),
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value.length < 7) {
                          return 'Password must be at least 7 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _password = value;
                      }),
                  SizedBox(
                    height: 12,
                  ),
                  widget.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.pink),
                          ),
                        )
                      : RaisedButton(
                          child: Text(_isSignupMode ? 'Register' : 'Login'),
                          onPressed: _trySubmit,
                        ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_isSignupMode
                        ? 'I already have an account'
                        : 'Create new account'),
                    onPressed: () {
                      setState(() {
                        _isSignupMode = !_isSignupMode;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
