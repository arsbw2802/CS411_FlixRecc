import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          child: Card(
            child: DeleteAccountForm(),
          ),
        ),
      ),
    );
  }
}

class DeleteAccountForm extends StatefulWidget {
  @override
  _DeleteAccountFormState createState() => _DeleteAccountFormState();
}

class _DeleteAccountFormState extends State<DeleteAccountForm> {
  final _usernameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _usernameTextController,
      _emailTextController,
      _passwordTextController
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

  Future deleteAccount() async {
    var response = await http.post(
      Uri.parse("http://localhost:5000" + "/deleteaccount"),
      headers: <String, String>{
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Access-Control-Allow-Headers": "Content-Type,Authorization",
        "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS"
      },
      body: jsonEncode(
          <String, String>{
            "_username": _usernameTextController.text,
            "_password": _passwordTextController.text,
            "_emailID": _emailTextController.text,
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
              controller: _emailTextController,
              decoration: const InputDecoration(hintText: 'email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _passwordTextController,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: () async {
              _formProgress >= 1 ? _showWelcomeScreen() : null;
              await deleteAccount();
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
