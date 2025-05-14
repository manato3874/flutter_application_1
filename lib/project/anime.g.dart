// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimeAdapter extends TypeAdapter<Anime> {
  @override
  final int typeId = 0;

  @override
  Anime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Anime(
      title: fields[0] as String,
      airDate: fields[1] as DateTime,
      musicTitle: fields[2] as String,
      youtubeUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Anime obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.airDate)
      ..writeByte(2)
      ..write(obj.musicTitle)
      ..writeByte(3)
      ..write(obj.youtubeUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
