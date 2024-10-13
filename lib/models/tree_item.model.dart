import '../constants/constants.dart';
import '../styles/styles.dart';

enum ItemType { location, asset, component }

abstract class TreeItem {
  final String id;
  final String name;
  final String? parentId;
  final Set<TreeItem> children = {};
  bool visible = true;

  TreeItem({
    required this.id,
    required this.name,
    this.parentId,
  });

  String get icon;

  List<TreeItem> get visibleChildren {
    return children.where((child) => child.visible).toList();
  }
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

  @override
  String get icon => AppIcons.location;
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

  @override
  String get icon => AppIcons.asset;
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

  @override
  String get icon => AppIcons.component;
}
