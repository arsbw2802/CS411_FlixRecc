import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flixrecc/arguments.dart';
import 'package:http/http.dart' as http;

class RecommendedPlaylist extends StatelessWidget {
  const RecommendedPlaylist();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          child: Card(
            child: ShowRecommendedList(),
          ),
        ),
      ),
    );
  }
}

class ShowRecommendedList extends StatefulWidget {
  @override
  _ShowRecommendedListState createState() => _ShowRecommendedListState();
}

class _ShowRecommendedListState extends State<ShowRecommendedList> {
  bool displaytable = false;
  // bool displaybutton = false;
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
    // print(username);
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
          child:Center(
            // alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'The following Movies/TV Shows are recommended to you: ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              ElevatedButton(
                child: Text('Fetch All the Movies/TV Shows Recommended to Me'),
                onPressed: () async {
                  await getRecommendedMovies(username);
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Add Movie or TV to Watch List', style: Theme.of(context).textTheme.headline4),
                        // Text(_formProgress.toString()),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _MovieNameTextController,
                            decoration: const InputDecoration(hintText: 'Name of the Movie/TV Show you want to add to your watch list'),
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
                          onPressed: () async{
                            _formProgress >= 1 ? await addToWatchList(username) : null;
                          },
                          child: const Text('Add'),
                        ),
                      ] // children 
                    )
                  )
                  

                  : Container(),
                SizedBox(
                          height: 10,
                        ),
            ]))));
  }

  Future getRecommendedMovies(username) async {
    print(username);
    var response = await http.get(
      Uri.parse("http://localhost:5000" + "/showrecommended/${username}"),
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

  Future<bool> addToWatchList(username) async{
    var response = await http.post(
      Uri.parse("http://localhost:5000" + "/addtowatchlist"),
      headers: <String, String>{
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Access-Control-Allow-Headers": "Content-Type,Authorization",
        "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS"
      },
      body: jsonEncode(
          <String, String>{
            "_movieName":_MovieNameTextController.text,
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
