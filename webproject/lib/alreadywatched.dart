import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flixrecc/arguments.dart';
import 'package:http/http.dart' as http;

class AlreadyWatchedPlaylist extends StatelessWidget {
  const AlreadyWatchedPlaylist();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          child: Card(
            child: ShowWatchedList(),
          ),
        ),
      ),
    );
  }
}

class ShowWatchedList extends StatefulWidget {
  @override
  _ShowWatchedListState createState() => _ShowWatchedListState();
}

class _ShowWatchedListState extends State<ShowWatchedList> {
  bool displaytable = false;
  dynamic jsonobjs;
  String? username;

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
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'I have Watched the Following Movies/TV Shows: ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              ElevatedButton(
                child: Text('Fetch All the Movies/TV Shows Watched by me'),
                onPressed: () async {
                  await getWatchedMovies(username);
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
                  : Container()
            ]))));
  }

  Future getWatchedMovies(username) async {
    print(username);
    var response = await http.get(
      Uri.parse("http://localhost:5000" + "/alreadywatched/${username}"),
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
    });

    return "";
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

