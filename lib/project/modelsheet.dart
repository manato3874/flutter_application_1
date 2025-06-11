import 'package:flutter/material.dart';

class GenreSelectorModal extends StatefulWidget {
  @override
  _GenreSelectorModalState createState() => _GenreSelectorModalState();
}

class _GenreSelectorModalState extends State<GenreSelectorModal> {
  String? selectedGenre;
  List<String> _genres = ['アクション', '恋愛', 'ホラー', 'コメディ'];

void _openGenreModal() async {
  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      List<String> genres = List.from(_genres); // 既存ジャンル（状態管理のためコピー）
      final newGenreController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setStateModal) => Padding(
          padding: MediaQuery.of(context).viewInsets, // キーボード対策
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var genre in genres)
                ListTile(
                  title: Text(genre),
                  onTap: () => Navigator.pop(context, genre),
                ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: newGenreController,
                  decoration: InputDecoration(
                    labelText: '新しいジャンルを追加',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        final newGenre = newGenreController.text.trim();
                        if (newGenre.isNotEmpty && !genres.contains(newGenre)) {
                          setStateModal(() {
                            genres.add(newGenre);
                            _genres.add(newGenre); // 外のジャンルリストも更新
                          });
                          newGenreController.clear();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (result != null) {
    setState(() {
      selectedGenre = result;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ジャンル', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: _openGenreModal,
          child: Text(selectedGenre ?? 'ジャンルを選択'),
        ),
      ],
    );
  }
}
