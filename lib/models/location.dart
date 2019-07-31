part of location_manager;

class Location {
  double latitude;
  double longitude;
  DateTime timestamp;
  double accuracy;
  double altitude;
  double heading;
  double speed;
  double speedAccuracy;


  Location({
    this.latitude,
    this.longitude,
    this.timestamp,
    this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    this.speedAccuracy
  });

  static Location fromMap(Map<String, dynamic> locationMap){
    if (locationMap == null) {
      throw ArgumentError('The parameter \'locationMap\' should not be null.');
    }

    if (!locationMap.containsKey('latitude')){
      throw ArgumentError.value(locationMap, 'locationMap',
          'The supplied map doesn\'t contain the mandatory key `latitude`.');
    }

    if (!locationMap.containsKey('longitude')){
      throw ArgumentError.value(locationMap, 'locationMap',
          'The supplied map doesn\'t contain the mandatory key `longitude`.');
    }


    final DateTime timestamp = locationMap['timestamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch((1000*double.parse('${locationMap['timestamp']}')).round())
        : DateTime(0);

    return Location(
        latitude: locationMap['latitude'],
        longitude: locationMap['longitude'],
        timestamp: timestamp,
        altitude: 1.0*(locationMap['altitude'] ?? 0.0),
        accuracy: 1.0*(locationMap['accuracy'] ?? 0.0),
        heading: 1.0*(locationMap['heading'] ?? 0.0),
        speed: 1.0*(locationMap['speed'] ?? 0.0),
        speedAccuracy: 1.0*(locationMap['speed_accuracy'] ?? 0.0)
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'latitude': this.latitude,
      'longitude': this.longitude,
      'timestamp': this.timestamp.toIso8601String(),
      'altitude': this.altitude,
      'accuracy': this.accuracy,
      'heading': this.heading,
      'speed': this.speed,
      'speed_accuracy': this.speedAccuracy,
    };
  }

  @override
  String toString() {
    return json.encode(toMap());
  }
}

class LocationError {
  int code;
  String message;

  LocationError(PlatformException e) {
    code = int.parse(e.code);
    message = e.message;
  }

  String toString() {
    return '>>> LocationError (code: $code, message: $message)';
  }
}