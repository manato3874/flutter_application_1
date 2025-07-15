import 'package:flutter/material.dart';
import 'package:flutter_application_1/submission/SecondPage.dart';


class FirstPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("ページ(1)")
      ),
      body : Center(
        child: TextButton(
          child: Text("2ページ目に遷移する"),
          // （1） 前の画面に戻る
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondPage(),
              ));
          },
        ),
      )
    );
  }
}