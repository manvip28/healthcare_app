// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VitalsAdapter extends TypeAdapter<Vitals> {
  @override
  final int typeId = 4;

  @override
  Vitals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vitals(
      patientId: fields[0] as String,
      heartRate: fields[1] as int,
      bloodPressure: fields[2] as String,
      bloodSugar: fields[3] as String,
      temperature: fields[4] as double,
      timestamp: fields[5] as DateTime,
      heartAttackSymptoms: (fields[6] as Map).cast<String, bool>(),
      hypoglycemicSymptoms: (fields[7] as Map).cast<String, bool>(),
      duration: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vitals obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.patientId)
      ..writeByte(1)
      ..write(obj.heartRate)
      ..writeByte(2)
      ..write(obj.bloodPressure)
      ..writeByte(3)
      ..write(obj.bloodSugar)
      ..writeByte(4)
      ..write(obj.temperature)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.heartAttackSymptoms)
      ..writeByte(7)
      ..write(obj.hypoglycemicSymptoms)
      ..writeByte(8)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VitalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
