import 'package:flutter/material.dart';

class AdvancedQueryPage extends StatelessWidget {
  const AdvancedQueryPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Output of your query'),
      ),
      body: Center(
        child: Text('The Query being performed is: '),
      ),

    );
  }
}