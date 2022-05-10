// import 'package:flutter/material.dart';
// import 'package:flixrecc/signup.dart';
// import 'package:flixrecc/login.dart';
// import 'package:flixrecc/homepage.dart';

// void main() => runApp(const MainApp());

// class MainApp extends StatelessWidget {
//   const MainApp();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       routes: {
//         '/': (context) => const LogInScreen(),
//         '/signup': (context) => const SignUpScreen(),
//         '/homepage': (context) => const HomeScreen(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flixrecc/signup.dart';
import 'package:flixrecc/login.dart';
import 'package:flixrecc/homepage.dart';
import 'package:flixrecc/userprofile.dart';
import 'package:flixrecc/recommended.dart';
import 'package:flixrecc/alreadywatched.dart';
import 'package:flixrecc/towatch.dart';
import 'package:flixrecc/updatepassword.dart';
import 'package:flixrecc/deleteaccount.dart';
import 'package:flixrecc/advancedquery.dart';
import 'package:flixrecc/searchscreen.dart';
import 'package:flixrecc/filterbymoviepref.dart';
import 'package:flixrecc/filterbyactor.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const LogInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/homepage': (context) => const HomeScreen(),
        '/userprofile': (context) => const UserProfile(),
        '/recommended': (context) => const RecommendedPlaylist(),
        '/alreadywatched': (context) => const AlreadyWatchedPlaylist(),
        '/towatch': (context) => const ToWatchPlaylist(),
        '/updatepassword': (context) => const UpdatePasswordScreen(),
        '/deleteaccount': (context) => const DeleteAccountScreen(),
        '/advancedquery': (context) => const AdvancedQueryPage(),
        '/searchscreen': (context) => const SearchScreen(),
        '/filterscreen': (context) => const FilterByMoviePrefScreen(),
        '/filteractorscreen': (context) => const FilterByActorPrefScreen(),
      },
    );
  }
}
