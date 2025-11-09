// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aluno.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlunoAdapter extends TypeAdapter<Aluno> {
  @override
  final int typeId = 1;

  @override
  Aluno read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Aluno(
      nome: fields[0] as String,
      idade: fields[1] as int,
      peso: fields[2] as double,
      treinos: (fields[3] as List).cast<Treino>(),
      registro: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Aluno obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.idade)
      ..writeByte(2)
      ..write(obj.peso)
      ..writeByte(3)
      ..write(obj.treinos)
      ..writeByte(4)
      ..write(obj.registro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlunoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
