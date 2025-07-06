// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlightAdapter extends TypeAdapter<Flight> {
  @override
  final int typeId = 0;

  @override
  Flight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flight(
      flightNumber: fields[1] as String,
      airline: fields[2] as String,
      from: fields[3] as String,
      to: fields[4] as String,
      departure: fields[5] as String,
      arrival: fields[6] as String,
      price: fields[7] as double,
      aircraft: fields[8] as String,
      duration: fields[9] as String,
      stops: fields[10] as int,
      seatsAvailable: fields[11] as int,
      travelClasses: (fields[12] as Map?)?.cast<String, TravelClass>(),
    );
  }

  @override
  void write(BinaryWriter writer, Flight obj) {
    writer
      ..writeByte(12)
      ..writeByte(1)
      ..write(obj.flightNumber)
      ..writeByte(2)
      ..write(obj.airline)
      ..writeByte(3)
      ..write(obj.from)
      ..writeByte(4)
      ..write(obj.to)
      ..writeByte(5)
      ..write(obj.departure)
      ..writeByte(6)
      ..write(obj.arrival)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.aircraft)
      ..writeByte(9)
      ..write(obj.duration)
      ..writeByte(10)
      ..write(obj.stops)
      ..writeByte(11)
      ..write(obj.seatsAvailable)
      ..writeByte(12)
      ..write(obj.travelClasses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TravelClassAdapter extends TypeAdapter<TravelClass> {
  @override
  final int typeId = 1;

  @override
  TravelClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TravelClass(
      price: fields[0] as double,
      seatsAvailable: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TravelClass obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.price)
      ..writeByte(1)
      ..write(obj.seatsAvailable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
