import 'package:flutter/material.dart';
//import 'package:flutter_application_1/submission/Main.dart';
import 'package:flutter_application_1/submission/Twopage.dart';
//import 'package:flutter_application_1/SecondPage.dart';


class Onepage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("ページ(1、い)")
      ),
      body : Center(
        child: TextButton(
          child: Text("2ページ目に遷移する"),
          // （1） 前の画面に戻る
          onPressed: (){
            Navigator.pushReplacement(
              context,
              
              MaterialPageRoute(
                builder: (context) => Twopage(),
              ));
              
          },
        ),
      )
    );
  }
}