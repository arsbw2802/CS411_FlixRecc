import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          child: Card(
            child: UpdatePasswordForm(),
          ),
        ),
      ),
    );
  }
}

class UpdatePasswordForm extends StatefulWidget {
  @override
  _UpdatePasswordFormState createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final _usernameTextController = TextEditingController();
  final _oldpasswordTextController = TextEditingController();
  final _newpasswordTextController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _usernameTextController,
      _oldpasswordTextController,
      _newpasswordTextController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length + 0.0000000002;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  Future<bool> changePassword() async {
    var response = await http.post(
      Uri.parse("http://localhost:5000" + "/updatepassword"),
      headers: <String, String>{
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{
            "_username":_usernameTextController.text,
            "_newpassword":_newpasswordTextController.text,
            "_oldpassword":_oldpasswordTextController.text,
          },
        ));
    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('FlixRecc', style: Theme.of(context).textTheme.headline4),
          // Text(_formProgress.toString()),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _oldpasswordTextController,
              decoration: const InputDecoration(hintText: 'Old Password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _newpasswordTextController,
              decoration: const InputDecoration(hintText: 'New Password'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Colors.blue;
              }),
            ),
            onPressed: () async {
              _formProgress >= 1 ? _showWelcomeScreen() : null;
              await changePassword();
            },
            child: const Text('Update Password and Log in'),
          ),
        ],
      ),
    );
  }
}