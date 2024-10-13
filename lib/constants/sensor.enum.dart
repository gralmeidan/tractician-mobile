enum SensorType {
  energy,
  vibration,
}

extension SensorTypeExtension on SensorType {
  String get name {
    switch (this) {
      case SensorType.energy:
        return 'energy';
      case SensorType.vibration:
        return 'vibration';
    }
  }
}

extension ListSensorTypeExtension on List<SensorType> {
  SensorType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'energy':
        return SensorType.energy;
      case 'vibration':
        return SensorType.vibration;
    }

    throw Exception('Invalid SensorType');
  }
}

enum SensorStatus {
  operating,
  alert,
}

extension SensorStatusExtension on SensorStatus {
  String get name {
    switch (this) {
      case SensorStatus.operating:
        return 'operating';
      case SensorStatus.alert:
        return 'alert';
    }
  }
}

extension ListSensorStatusExtension on List<SensorStatus> {
  SensorStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'operating':
        return SensorStatus.operating;
      case 'alert':
        return SensorStatus.alert;
    }

    throw Exception('Invalid SensorStatus');
  }
}
