import 'package:flutter/material.dart';
//import 'package:flutter_application_1/HomePage.dart';
import 'package:flutter_application_1/submission/Main.dart';

class Fourpage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("ページ(4、お)")
      ),
      body : Center(
        child: TextButton(
          child: Text("最初のページに戻る"),
          // （1） 前の画面に戻る
          onPressed: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Main(),
              ));
          },
        ),
      )
    );
  }
}