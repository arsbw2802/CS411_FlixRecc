import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatelessWidget {
  const SignUpScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _genderTextController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController,
      _passwordTextController,
      _emailTextController,
      _ageTextController,
      _genderTextController
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

  Future createAccount() async {
    var response =
        await http.post(Uri.parse("http://localhost:5000" + "/signup"),
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
                "_age": _ageTextController.text,
                "_gender": _genderTextController.text
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
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
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
              controller: _passwordTextController,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _emailTextController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _ageTextController,
              decoration: const InputDecoration(hintText: 'Age'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _genderTextController,
              decoration: const InputDecoration(hintText: 'Gender'),
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
              await createAccount();
            },
            child: const Text('Sign up!'),
          ),
        ],
      ),
    );
  }
}
