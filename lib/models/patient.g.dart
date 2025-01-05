// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final int typeId = 3;

  @override
  Patient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patient(
      id: fields[0] as String,
      name: fields[1] as String,
      age: fields[2] as int,
      gender: fields[3] as String,
      vitals: (fields[4] as List).cast<Vitals>(),
      records: (fields[5] as List).cast<MedicalRecord>(),
      diagnosis: fields[6] as String,
      medicalHistory: fields[7] as String?,
      allergies: fields[8] as String?,
      familyMedicalHistory: fields[9] as String?,
      medications: fields[10] as String?,
      ongoingTreatments: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.vitals)
      ..writeByte(5)
      ..write(obj.records)
      ..writeByte(6)
      ..write(obj.diagnosis)
      ..writeByte(7)
      ..write(obj.medicalHistory)
      ..writeByte(8)
      ..write(obj.allergies)
      ..writeByte(9)
      ..write(obj.familyMedicalHistory)
      ..writeByte(10)
      ..write(obj.medications)
      ..writeByte(11)
      ..write(obj.ongoingTreatments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
