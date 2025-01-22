import 'package:flutter/material.dart';
import 'package:flutter_application_1/submission/Fourpage.dart';
//import 'package:flutter_application_1/HomePage.dart';

class Threepage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("ページ(3、え)")
      ),
      body : Center(
        child: TextButton(
          child: Text("最初のページに戻る"),
          // （1） 前の画面に戻る
          onPressed: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Fourpage(),
              ));
          },
        ),
      )
    );
  }
}