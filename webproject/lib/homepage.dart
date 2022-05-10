import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flixrecc/arguments.dart';
// import 'package:flixrecc/userprofile.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        child: Card(
          child: HomePage(),
        ),
      ),
    ));
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool displaytable_mov = false;
  bool displaytable_tv = false;
  dynamic jsonobjs_mov;
  dynamic jsonobjs_tv;

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('FlixRecc');

  void _showMyProfileScreen() {
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
    Navigator.pushNamed(context, '/userprofile',
        arguments: UserArguments(args.userName));
  }

  void _showSearchScreen() {
    // Navigator.of(context).pushNamed('/searchscreen');
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
    Navigator.pushNamed(context, '/searchscreen',
        arguments: UserArguments(args.userName));
  }

  void _showFilterScreen() {
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
    Navigator.pushNamed(context, '/filterscreen',
        arguments: UserArguments(args.userName));
    // Navigator.of(context).pushNamed('/filterscreen');
  }

  void _showActorFilterScreen() {
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
    Navigator.pushNamed(context, '/filteractorscreen',
        arguments: UserArguments(args.userName));
    // Navigator.of(context).pushNamed('/filteractorscreen');
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        // toolbarHeight: 100,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              // size: 26.0,
              color: Colors.white,
            ),
            onPressed: _showSearchScreen,
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              // size: 26.0,
              color: Colors.white,
            ),
            onPressed: _showMyProfileScreen,
          ),
          IconButton(
            icon: Icon(Icons.logout
                // size: 26.0,
                // color: Colors.white,
                ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Text('Welcome Back ${args.userName}!',
                style: Theme.of(context).textTheme.headline4),
            SizedBox(
              height: 30,
            ),
            Text('Choose which of the filters you want to to choose for recommendations:',
                style: Theme.of(context).textTheme.headline5),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Filter By Genre Preference"),
              onPressed: _showFilterScreen,
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(20),
                  textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: Text("Filter By Actor/Actress Name"),
              onPressed: _showActorFilterScreen,
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(20),
                  textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            SizedBox(
              height: 30,
            ),
            Text('Check which are the most liked Movies and TV Shows:',
                style: Theme.of(context).textTheme.headline5),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Fetch the Most Liked Movies"),
              onPressed: () async {
                await getTopMovies();
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
              height: 10,
            ),
            ElevatedButton(
              child: Text("Fetch the Most Liked TV Shows"),
              onPressed: () async {
                await getTopTV();
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
              height: 20,
            ),
            displaytable_mov
                  ? DataTable(columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Movie Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Movie Count',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Movie Rating',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ], rows: getMovieRows())
                  : displaytable_tv
                    ? DataTable(columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'TV Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'TV Count',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'TV Rating',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ], rows: getTVRows())
                    : Container(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        )
      ),
    );
  }

  Future<String> getTopMovies() async {
      http.Response response = await http.get(
          Uri.parse("http://localhost:5000" + "/showpopmovies"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      jsonobjs_mov = jsonDecode(jsonDecode(response.body)["data"]);
      setState(() { 
        displaytable_mov = true;
        displaytable_tv = false;
        });
      return "";
    }
  
  Future<String> getTopTV() async {
      http.Response response = await http.get(
          Uri.parse("http://localhost:5000" + "/showpoptv"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      jsonobjs_tv = jsonDecode(jsonDecode(response.body)["data"]);
      setState(() { 
        displaytable_mov = false;
        displaytable_tv = true;
        });
      return "";
    }

    List<DataRow> getMovieRows() {
      List<DataRow> toReturn = [];
      for (dynamic data in jsonobjs_mov) {
      var currData = json.decode(data);
        toReturn.add(
          DataRow(
            cells: <DataCell>[
              DataCell(Text(currData["movieName"])),
              DataCell(Text(currData["movieCount"])),
              DataCell(Text(currData["moviePop"])),
            ],
          ),
        );
      }
      return toReturn;
    }

    List<DataRow> getTVRows() {
      List<DataRow> toReturn = [];
      for (dynamic data in jsonobjs_tv) {
      var currData = json.decode(data);
        toReturn.add(
          DataRow(
            cells: <DataCell>[
              DataCell(Text(currData["tvName"])),
              DataCell(Text(currData["tvCount"])),
              DataCell(Text(currData["tvPop"])),
            ],
          ),
        );
      }
      return toReturn;
    }
}