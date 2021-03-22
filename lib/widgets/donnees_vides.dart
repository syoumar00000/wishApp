import 'package:flutter/material.dart';

 class DonneesVides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Text("Acune donnée n'est présente",
      textScaleFactor: 2.5,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: Colors.red,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
