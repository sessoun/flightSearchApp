// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_flight_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteFlightModelAdapter extends TypeAdapter<FavoriteFlightModel> {
  @override
  final int typeId = 0;

  @override
  FavoriteFlightModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteFlightModel(
      flightNumber: fields[0] as String,
      airline: fields[1] as String,
      from: fields[2] as String,
      to: fields[3] as String,
      departure: fields[4] as String,
      arrival: fields[5] as String,
      price: fields[6] as double,
      aircraft: fields[7] as String,
      duration: fields[8] as String,
      stops: fields[9] as int,
      seatsAvailable: fields[10] as int,
      travelClass: fields[11] as String,
      favoriteDate: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteFlightModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.flightNumber)
      ..writeByte(1)
      ..write(obj.airline)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.to)
      ..writeByte(4)
      ..write(obj.departure)
      ..writeByte(5)
      ..write(obj.arrival)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.aircraft)
      ..writeByte(8)
      ..write(obj.duration)
      ..writeByte(9)
      ..write(obj.stops)
      ..writeByte(10)
      ..write(obj.seatsAvailable)
      ..writeByte(11)
      ..write(obj.travelClass)
      ..writeByte(12)
      ..write(obj.favoriteDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteFlightModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
