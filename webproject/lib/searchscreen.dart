import 'dart:convert';
import 'package:flixrecc/arguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatelessWidget {
  const SearchScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        child: Card(
          child: MovieSearchForm(),
        ),
      ),
    ));
  }
}

class MovieSearchForm extends StatefulWidget {
  @override
  _MovieSearchFormState createState() => _MovieSearchFormState();
}

class _MovieSearchFormState extends State<MovieSearchForm> {
  final _movieNameTextController = TextEditingController();
  String? username;
  dynamic jsonobjs;
  bool displaytable = false;
  double _formProgress = 0;
  String movieName = "";
  bool displaybutton = false;
  bool todisplaybutton = false;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [_movieNameTextController];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length + 0.0000000002;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  // void _showWelcomeScreen() {
  //   Navigator.of(context).pushNamed('/homepage');
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
    username = args.userName;

    return Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(children: [
            Form(
              onChanged: _updateFormProgress,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('FlixRecc',
                      style: Theme.of(context).textTheme.headline4),
                  // Text(_formProgress.toString()),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _movieNameTextController,
                      decoration: const InputDecoration(hintText: 'Movie name'),
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
                      // _formProgress >= 1 ? _showWelcomeScreen() : null;
                      await SearchMovie();
                    },
                    child: const Text('Search!'),
                  ),

                  displaytable
                      ? DataTable(columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'titleId',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Title',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'genre',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'startYear',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'averageRating',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Directors',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'RuntimeMinutes',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'isAdult',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'LeadRole',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ], rows: getRows())
                      : Container(),
                  todisplaybutton
                      ? ElevatedButton(
                          child: Text('Add Movie to my Watch List'),
                          onPressed: () async {
                            await addToWatchList(username);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              padding: EdgeInsets.all(20),
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        )
                      : Container(),
                ],
              ),
            ),
          ]),
        ));
  }

  Future SearchMovie() async {
    var response = await http.get(
      Uri.parse(
          "http://localhost:5000" + "/search/${_movieNameTextController.text}"),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Access-Control-Allow-Headers": "Content-Type,Authorization",
        "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS"
      },
    );

    jsonobjs = jsonDecode(jsonDecode(response.body)["data"]);

    setState(() {
      // outputlist = jsonDecode(response.body);
      // print(outputlist);
      displaytable = true;
    });
    return "";
  }

  List<DataRow> getRows() {
    List<DataRow> toReturn = [];
    for (dynamic data in jsonobjs) {
      var currData = json.decode(data);
      movieName = currData["title"];
      todisplaybutton = true;
      print(movieName);
      print(todisplaybutton);
      toReturn.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(currData["titleID"])),
            DataCell(Text(currData["title"])),
            DataCell(Text(currData["genres"])),
            DataCell(Text(currData["startYear"])),
            DataCell(Text(currData["averageRating"])),
            DataCell(Text(currData["directors"])),
            DataCell(Text(currData["runtimeMinutes"])),
            DataCell(Text(currData["isAdult"])),
            DataCell(Text(currData["leadRole"])),
          ],
        ),
      );
    }
    return toReturn;
  }

  Future<bool> addToWatchList(username) async {
    var response =
        await http.post(Uri.parse("http://localhost:5000" + "/addtowatchlist"),
            headers: <String, String>{
              "Accept": "application/json",
              "Access-Control-Allow-Origin": "*",
              "Content-Type": "application/json; charset=UTF-8",
              "Access-Control-Allow-Headers": "Content-Type,Authorization",
              "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS"
            },
            body: jsonEncode(
              <String, String>{"_movieName": movieName, "_username": username},
            ));
    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }
}
