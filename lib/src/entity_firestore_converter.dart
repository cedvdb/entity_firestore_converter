import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entity/entity.dart';

typedef FromMap<T> = T Function(Map<String, dynamic>);
typedef ToMap<T> = Map<String, dynamic> Function(T);

/// This is a converter for firestore to convert from document snapshot
/// to entities and back.
///
/// If the [serverSideTimeStampTimeout] is specified,
/// DateTime in the object will be converted to server side timestamp
/// if those are between the moment of update MU and MU - timeout.
/// The default is null (no effect)
class EntityFirestoreConverter<R extends Entity> {
  final FromMap _fromMap;
  final Duration? _nowTimeout;

  EntityFirestoreConverter({
    Duration? serverSideTimeStampTimeout,
    required FromMap fromMap,
  })  : _nowTimeout = serverSideTimeStampTimeout,
        _fromMap = fromMap;

  R? fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    if (!doc.exists) {
      return null;
    }
    var map = doc.data()!;
    map['id'] = doc.id;
    map['metadata'] = {
      'hasPendingWrites': doc.metadata.hasPendingWrites,
    };
    map = convertFirebaseTimestamps(map);
    return _fromMap(map);
  }

  Map<String, dynamic> toFirestore(
    R? entity,
    SetOptions? options,
  ) {
    var resultMap = entity?.toMap() ?? {};
    resultMap.remove('id');
    resultMap.remove('metadata');
    resultMap = convertToServerSideTimestamp(resultMap);
    return resultMap;
  }

  Map<String, dynamic> convertFirebaseTimestamps(Map<String, dynamic> map) {
    for (final entry in map.entries) {
      var value = entry.value;
      // if the value is a google timestamp we convert it to a datetime
      if (value is Timestamp) {
        value = value.toDate();
      }
      if (value is List && value.isNotEmpty && value[0] is Map) {
        value = value.map((el) => convertFirebaseTimestamps(el)).toList();
      }
      if (value is Map<String, dynamic>) {
        value = convertFirebaseTimestamps(value);
      }
      map[entry.key] = value;
    }
    return map;
  }

  Map<String, dynamic> convertToServerSideTimestamp(Map<String, dynamic> map) {
    final nowTimeout = _nowTimeout;
    if (nowTimeout == null) return map;
    for (final entry in map.entries) {
      var value = entry.value;
      if (value is DateTime) {
        final nowStart = DateTime.now().subtract(nowTimeout);
        final nowEnd = DateTime.now();
        final isNow = value.isAfter(nowStart) && value.isBefore(nowEnd);
        if (isNow) {
          value = FieldValue.serverTimestamp();
        }
      }
      if (value is List && value.isNotEmpty && value[0] is Map) {
        value = value.map((el) => convertToServerSideTimestamp(el)).toList();
      }
      if (value is Map<String, dynamic>) {
        value = convertToServerSideTimestamp(value);
      }
      map[entry.key] = value;
    }
    return map;
  }
}
