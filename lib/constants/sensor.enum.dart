import 'package:flutter/material.dart';

import '../styles/styles.dart';

enum SensorType {
  energy,
  vibration,
}

extension SensorTypeExtension on SensorType {
  IconData get icon {
    switch (this) {
      case SensorType.energy:
        return Icons.bolt_outlined;
      case SensorType.vibration:
        return Icons.circle;
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
  Color get color {
    switch (this) {
      case SensorStatus.operating:
        return AppColors.green;
      case SensorStatus.alert:
        return AppColors.red;
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
