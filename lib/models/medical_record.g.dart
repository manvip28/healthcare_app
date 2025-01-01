// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicalRecordAdapter extends TypeAdapter<MedicalRecord> {
  @override
  final int typeId = 2;

  @override
  MedicalRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicalRecord(
      diagnosis: fields[0] as String,
      prescription: (fields[1] as List).cast<String>(),
      notes: fields[2] as String,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MedicalRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.diagnosis)
      ..writeByte(1)
      ..write(obj.prescription)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
