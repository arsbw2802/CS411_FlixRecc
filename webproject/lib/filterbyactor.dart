import 'dart:convert';
import 'package:flixrecc/arguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FilterByActorPrefScreen extends StatelessWidget {
  const FilterByActorPrefScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Filter By Movie Preference'),
      ),
      body: Center(
        child: SizedBox(
          child: Card(
            child: FilterByActorPrefForm(),
          ),
        ),
      ),
    );
  }
}

class FilterByActorPrefForm extends StatefulWidget {
  @override
  _FilterByActorPrefFormState createState() => _FilterByActorPrefFormState();
}

class _FilterByActorPrefFormState extends State<FilterByActorPrefForm> {
  final _actorNameTextController = TextEditingController();
  dynamic jsonobjs;
  double _formProgress = 0;
  String? username;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [_actorNameTextController];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length + 0.0000000002;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
    username = args.userName;
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Type in your favorite actor/actress name',
              style: Theme.of(context).textTheme.headline5),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _actorNameTextController,
              decoration: const InputDecoration(hintText: 'Actor/Actress name'),
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
              await filterbyActorName(username);
            },
            child: const Text('Go!'),
          ),
        ],
      ),
    );
  }

  Future filterbyActorName(username) async {
    var response = await http.post(
        Uri.parse("http://localhost:5000" + "/filterbyactorscreen"),
        headers: <String, String>{
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json; charset=UTF-8",
          "Access-Control-Allow-Headers": "Content-Type,Authorization",
          "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS"
        },
        body: jsonEncode(
          <String, String>{
            "_username": username,
            "_actorname": _actorNameTextController.text,
          },
        ));

    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }
}
