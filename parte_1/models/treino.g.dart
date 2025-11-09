// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treino.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TreinoAdapter extends TypeAdapter<Treino> {
  @override
  final int typeId = 0;

  @override
  Treino read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Treino(
      id: fields[0] as int,
      nome: fields[1] as String,
      descricao: fields[2] as String,
      repeticoes: fields[3] as int,
      carga: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Treino obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.descricao)
      ..writeByte(3)
      ..write(obj.repeticoes)
      ..writeByte(4)
      ..write(obj.carga);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreinoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
