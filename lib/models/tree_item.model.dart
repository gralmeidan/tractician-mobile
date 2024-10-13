import '../constants/constants.dart';

enum ItemType { location, asset, component }

abstract class TreeItem {
  final String id;
  final String name;
  final Set<TreeItem> children;
  final String? parentId;

  TreeItem({
    required this.id,
    required this.name,
    this.parentId,
  }) : children = {};
}

class Location extends TreeItem {
  Location({
    required super.id,
    required super.name,
    super.parentId,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] ?? json['locationId'],
    );
  }
}

class Asset extends TreeItem {
  Asset({
    required super.id,
    required super.name,
    super.parentId,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    if (json['sensorType'] is String) {
      return Component(
        id: json['id'] as String,
        name: json['name'] as String,
        sensorType: SensorType.values.fromString(json['sensorType'] as String),
        sensorStatus: SensorStatus.values.fromString(json['status'] as String),
        parentId: json['parentId'] ?? json['locationId'],
      );
    }

    return Asset(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] ?? json['locationId'],
    );
  }
}

class Component extends Asset {
  final SensorType sensorType;
  final SensorStatus sensorStatus;

  Component({
    required super.id,
    required super.name,
    required this.sensorType,
    required this.sensorStatus,
    super.parentId,
  });
}
