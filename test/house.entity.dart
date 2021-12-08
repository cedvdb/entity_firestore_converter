import 'package:entity/entity.dart';

final mockHouse = House.forCreation(
  createdBy: 'user-id1',
  windows: 4,
  swimmingPool: true,
  buildDate: DateTime.now(),
  owners: [
    Owner(
      name: 'jack',
      birthday: DateTime.now(),
    )
  ],
);

class House extends Entity {
  final int windows;
  final bool swimmingPool;
  final DateTime buildDate;
  final List<Owner> owners;
  House({
    required String id,
    required Audit audit,
    required Metadata metadata,
    required this.windows,
    required this.swimmingPool,
    required this.buildDate,
    required this.owners,
  }) : super(id: id, audit: audit, metadata: metadata);

  House.forCreation({
    required String createdBy,
    required this.windows,
    required this.swimmingPool,
    required this.buildDate,
    required this.owners,
  }) : super(
          id: '',
          audit: Audit.forCreation(createdBy),
          metadata: Metadata.forCreation(),
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'audit': audit.toMap(),
      'metadata': metadata.toMap(),
      'windows': windows,
      'swimmingPool': swimmingPool,
      'buildDate': buildDate.millisecondsSinceEpoch,
      'owners': owners.map((x) => x.toMap()).toList(),
    };
  }

  factory House.fromMap(Map<String, dynamic> map) {
    return House(
      id: map['id'],
      metadata: Metadata.fromMap(map['metadata']),
      audit: Audit.fromMap(map['audit']),
      windows: map['windows'],
      swimmingPool: map['swimmingPool'],
      buildDate: DateTime.fromMillisecondsSinceEpoch(map['buildDate']),
      owners: List<Owner>.from(map['owners']?.map((x) => Owner.fromMap(x))),
    );
  }
}

class Owner {
  final String name;
  final DateTime birthday;
  Owner({
    required this.name,
    required this.birthday,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthday': birthday.millisecondsSinceEpoch,
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      name: map['name'],
      birthday: DateTime.fromMillisecondsSinceEpoch(map['birthday']),
    );
  }
}
