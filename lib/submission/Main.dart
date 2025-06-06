import 'package:flutter/material.dart';
import 'package:flutter_application_1/submission/Onepage.dart';

class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム(あ)"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TextButton(
              child: Text("1ページ目に遷移する"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Onepage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
