// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VitalsAdapter extends TypeAdapter<Vitals> {
  @override
  final int typeId = 1;

  @override
  Vitals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vitals(
      heartRate: fields[0] as int,
      bloodPressure: fields[1] as String,
      temperature: fields[2] as double,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Vitals obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.heartRate)
      ..writeByte(1)
      ..write(obj.bloodPressure)
      ..writeByte(2)
      ..write(obj.temperature)
      ..writeByte(3)
      ..write(obj.timestamp);
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
