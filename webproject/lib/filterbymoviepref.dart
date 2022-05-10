import 'dart:convert';
import 'package:flixrecc/arguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FilterByMoviePrefScreen extends StatelessWidget {
  const FilterByMoviePrefScreen();

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
            child: FilterByMoviePrefForm(),
          ),
        ),
      ),
    );
  }
}

class FilterByMoviePrefForm extends StatefulWidget {
  @override
  _FilterByMoviePrefFormState createState() => _FilterByMoviePrefFormState();
}

class _FilterByMoviePrefFormState extends State<FilterByMoviePrefForm> {
  bool _value = false;
  bool _value_r = false;
  int val = -1;
  int val_r = -1;
  String moviegenre = "";
  String? username;
  dynamic jsonobjs;
  bool displaytable = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
    username = args.userName;
    return Scaffold(
      body: SingleChildScrollView(

      // onChanged: _updateFormProgress,
      child: Center(
        child:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
                height: 20,
              ),
        ElevatedButton(
                child: Text('Get Runtimes of every Genre'),
                onPressed: () async {
                  await performquery1();
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
            displaytable
                  ? DataTable(columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'genres',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Average Runtime',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ], rows: getRows())
                  : Container(),
        Form(
          child: Column(
            children: [
          Text('Choose one of the following genres',
              style: Theme.of(context).textTheme.headline5),
          ListTile(
            title: Text("Animation"),
            leading: Radio(
              value: 0,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                  moviegenre = "Animation";
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("Comedy"),
            leading: Radio(
              value: 1,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                  moviegenre = "Comedy";
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("Documentary"),
            leading: Radio(
              value: 2,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                  moviegenre = "Documentary";
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          // ListTile(
          //   title: Text("Short"),
          //   leading: Radio(
          //     value: 3,
          //     groupValue: val,
          //     onChanged: (value) {
          //       setState(() {
          //         val = value as int;
          //         moviegenre = "Short";
          //       });
          //     },
          //     activeColor: Colors.blue,
          //   ),
          // ),
          ListTile(
            title: Text("Romance"),
            leading: Radio(
              value: 4,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                  moviegenre = "Romance";
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          // ListTile(
          //   title: Text("News"),
          //   leading: Radio(
          //     value: 5,
          //     groupValue: val,
          //     onChanged: (value) {
          //       setState(() {
          //         val = value as int;
          //         moviegenre = "News";
          //       });
          //     },
          //     activeColor: Colors.blue,
          //   ),
          // ),
          ListTile(
            title: Text("Drama"),
            leading: Radio(
              value: 6,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                  moviegenre = "Drama";
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("Fantasy"),
            leading: Radio(
              value: 7,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                  moviegenre = "Fantasy";
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("Horror"),
            leading: Radio(
              value: 8,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                  moviegenre = "Horror";
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          // ListTile(
          //   title: Text("Music"),
          //   leading: Radio(
          //     value: 9,
          //     groupValue: val,
          //     onChanged: (value) {
          //       setState(() {
          //         val = value as int;
          //         moviegenre = "Music";
          //       });
          //     },
          //     activeColor: Colors.blue,
          //   ),
          // ),
          ListTile(
            title: Text("Crime"),
            leading: Radio(
              value: 10,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                  moviegenre = "Crime";
                });
              },
              activeColor: Colors.blue,
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
              await filterbygenre(username);
            },
            child: const Text('Go!'),
          ),
            ]
            ),
          ),
        ],
      ),
      )
      )
    );
  }

  Future filterbygenre(username) async {
    var response =
        await http.post(Uri.parse("http://localhost:5000" + "/filtergenre"),
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
                "_genre": moviegenre,
              },
            ));

    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future performquery1() async {
    http.Response response = await http.get(
        Uri.parse("http://localhost:5000" + "/query1"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    jsonobjs = json.decode(json.decode(response.body)["data"]);

    // jsonobjs = jsonDecode(response.body);
    // print(jsonobjs);
    setState(() {
      // outputlist = jsonDecode(response.body);
      // print(outputlist);
      displaytable = true;
    });
    // print(outputlist);
    // it = jsonDecode(response.body);
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
            DataCell(Text(currData["genre"])),
            DataCell(Text(currData["avgRuntime"])),
          ],
        ),
      );
    }
    return toReturn;
  }
}







              // ElevatedButton(
              //   child: Text('Perform Query 1'),
              //   onPressed: () async {
              //     await performquery1();
              //   },
              //   style: ElevatedButton.styleFrom(
              //       primary: Colors.blue,
              //       padding: EdgeInsets.all(20),
              //       textStyle: TextStyle(
              //           fontSize: 15,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black)),
              // ),
              // SizedBox(
              //   height: 4,
              // ),
              // displaytable
              //     ? DataTable(columns: const <DataColumn>[
              //         DataColumn(
              //           label: Text(
              //             'genres',
              //             style: TextStyle(fontStyle: FontStyle.italic),
              //           ),
              //         ),
              //         DataColumn(
              //           label: Text(
              //             'Average Runtime',
              //             style: TextStyle(fontStyle: FontStyle.italic),
              //           ),
              //         ),
              //       ], rows: getRows())
              //     : Container()
