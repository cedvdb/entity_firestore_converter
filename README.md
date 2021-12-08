Converter for firestore


# Usage

```dart
  final converter = EntityFirestoreConverter<House>(fromMap: House.fromMap);
  final collectionReference = firestore.collection(col).withConverter<House>(
        fromFirestore: converter.fromFirestore,
        toFirestore: converter.toFirestore,
      );
  final listResult = await firestore.collection(col).get();
  List<House> house = listResult.data();
  final oneResult = await firestore.collection(col).doc('x').get();
  House? house = oneResult.data();
```

### serverSideTimeStampTimeout

If the [serverSideTimeStampTimeout] is specified, DateTime in the object will be converted to server side timestamp
if those are between the moment of update MU and MU - timeout.

The default is null (no effect)