import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entity_firestore_converter/entity_firestore_converter.dart';
import 'package:test/test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'house.entity.dart';

void main() {
  final col = 'houses';
  late FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
  late EntityFirestoreConverter<House> converter;
  late CollectionReference<House?> collectionReference;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    converter = EntityFirestoreConverter<House>(fromMap: House.fromMap);
    firestore.collection(col).add(mockHouse.toMap());
    collectionReference = firestore.collection(col).withConverter<House?>(
          fromFirestore: converter.fromFirestore,
          toFirestore: converter.toFirestore,
        );
  });

  test('Should convert from snapshot to entity', () async {
    final result = await collectionReference.get();
    expect(result.data().first, isA<House>());
  });

  test('Should convert from snapshot to null if not exist', () async {
    final result = await collectionReference.doc('not-exists').get();
    expect(result.data() == null, isTrue);
  });

  test('Should convert from entity to snapshot', () async {
    final result1 = await firestore.collection(col).get();
    expect(result1.docs.length, equals(1));
    collectionReference.add(mockHouse);
    final result2 = await firestore.collection(col).get();
    expect(result2.docs.length, equals(2));
  });
}
