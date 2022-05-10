import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flixrecc/arguments.dart';
import 'package:http/http.dart' as http;

class ToWatchPlaylist extends StatelessWidget {
  const ToWatchPlaylist();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          child: Card(
            child: ShowToWatchList(),
          ),
        ),
      ),
    );
  }
}

class ShowToWatchList extends StatefulWidget {
  @override
  _ShowToWatchListState createState() => _ShowToWatchListState();
}

class _ShowToWatchListState extends State<ShowToWatchList> {
  bool displaytable = false;
  bool displayform = false;

  dynamic jsonobjs;
  String? username;

  final _MovieNameTextController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [_MovieNameTextController];

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
    print(username);
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
        body: SingleChildScrollView(
          child: Center(
            // alignment: Alignment.center,
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'You want to watch the following movies/TV Shows: ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              ElevatedButton(
                child: Text('Fetch All the Movies/TV Shows I want to Watch'),
                onPressed: () async {
                  await getToWatchMovies(username);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.all(20),
                    textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(
                height: 4,
              ),
              displaytable
                  ? DataTable(columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Movie Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ], rows: getRows())
                  : Container(),
              displayform
                  ? Form(
                      onChanged: _updateFormProgress,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('Add Movie or TV to Already Watched List',
                            style: Theme.of(context).textTheme.headline4),
                        // Text(_formProgress.toString()),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _MovieNameTextController,
                            decoration: const InputDecoration(
                                hintText:
                                    'Name of the Movie/TV Show you have finished watching'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                            _formProgress >= 1
                                ? await addToAlreadyWatchedList(username)
                                : null;
                          },
                          child: const Text('Add'),
                        ),
                      ] // children
                          ))
                  : Container(),
            ]))));
  }

  Future getToWatchMovies(username) async {
    print(username);
    var response = await http.get(
      Uri.parse("http://localhost:5000" + "/towatch/${username}"),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Access-Control-Allow-Headers": "Content-Type,Authorization",
        "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS"
      },
    );

    jsonobjs = jsonDecode(jsonDecode(response.body)["data"]);

    setState(() {
      displaytable = true;
      displayform = true;
    });

    return "";
  }

  Future<bool> addToAlreadyWatchedList(username) async {
    var response = await http.post(
        Uri.parse("http://localhost:5000" + "/addtoalreadywatchedlist"),
        headers: <String, String>{
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json; charset=UTF-8",
          "Access-Control-Allow-Headers": "Content-Type,Authorization",
          "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS"
        },
        body: jsonEncode(
          <String, String>{
            "_movieName": _MovieNameTextController.text,
            "_username": username
          },
        ));
    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  List<DataRow> getRows() {
    List<DataRow> toReturn = [];
    for (dynamic data in jsonobjs) {
      var currData = json.decode(data);
      print(currData);
      toReturn.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(currData["MovieName"])),
          ],
        ),
      );
    }
    return toReturn;
  }
}
