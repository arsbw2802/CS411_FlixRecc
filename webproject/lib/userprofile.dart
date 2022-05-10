import 'dart:convert';
import 'package:flixrecc/arguments.dart';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatelessWidget {
  const UserProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          child: Card(
            child: ShowUserProfile(),
          ),
        ),
      ),
    );
  }
}

class ShowUserProfile extends StatefulWidget {
  @override
  _ShowUserProfileState createState() => _ShowUserProfileState();
}

class _ShowUserProfileState extends State<ShowUserProfile> {
  bool displaytable = false;
  // Map<String, int> jsonobjs;
  // String output = "";
  dynamic jsonobjs;

  // void _showMyProfileScreen() {
  //   final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
  //   Navigator.pushNamed(context, '/userprofile',
  //       arguments: UserArguments(args.userName));
  // }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;

    void _showMyRecommendedPlaylist() {
      Navigator.pushNamed(context, '/recommended', arguments: UserArguments(args.userName));
    }

    void _showMyWatchedList() {
      // Navigator.of(context).pushNamed('/alreadywatched');
      Navigator.pushNamed(context, '/alreadywatched', arguments: UserArguments(args.userName));
    }

    void _showMyToWatchList() {
      // Navigator.of(context).pushNamed('/towatch');
      Navigator.pushNamed(context, '/towatch', arguments: UserArguments(args.userName));
    }

    void _showAdvancedQuery() {
      Navigator.of(context).pushNamed('/advancedquery');
    }

    final queryoutput = TextEditingController();
    // List outputlist = [];
    // String var;
    // String it = "";

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
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Choose which list of Movies/TV Shows you want to view: ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              ElevatedButton(
                child: Text('Movies/TV Shows Recommended for you'),
                onPressed: _showMyRecommendedPlaylist,
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
              ElevatedButton(
                child: Text('Movies/TV Shows you have already watched'),
                onPressed: _showMyWatchedList,
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
              ElevatedButton(
                child: Text('Movies/TV Shows you want to watch'),
                onPressed: _showMyToWatchList,
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

              // Padding(
              //   padding: const EdgeInsets.all(1.0),
              //   child: TextFormField(jsonobjs),
              // ),
              
              // ListView.builder(
              //     scrollDirection: Axis.vertical,
              //     shrinkWrap: true,
              //     itemCount: outputlist.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         leading: Text(outputlist.toString()),
              //       );
              //     })
            ],
          )),
    );
  }

  
}
