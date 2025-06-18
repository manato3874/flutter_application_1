import 'package:flutter/material.dart';

Future<String?> showGenreSelectorModal(BuildContext context, List<String> genres) async {
  final newGenreController = TextEditingController();
  List<String> genreList = List.from(genres);
  String? errorText;

  return await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateModal) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ジャンルを選択または追加',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: newGenreController,
                decoration: InputDecoration(
                  labelText: '新しいジャンルを追加',
                  errorText: errorText,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      final newGenre = newGenreController.text.trim();
                      if (newGenre.isEmpty) {
                        setStateModal(() {
                          errorText = 'ジャンルを入力してください';
                        });
                      } else if (genreList.contains(newGenre)) {
                        setStateModal(() {
                          errorText = '既に存在しています';
                        });
                      } else {
                        setStateModal(() {
                          genreList.add(newGenre);
                          newGenreController.clear();
                          errorText = null;
                        });
                      }
                    },
                  ),
                ),
              ),
              Divider(),
              ...genreList.map((genre) => ListTile(
                    leading: Icon(Icons.label_outline),
                    title: Text(genre),
                    onTap: () => Navigator.pop(context, genre),
                  )),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
