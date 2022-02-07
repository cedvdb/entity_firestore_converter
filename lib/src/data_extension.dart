import 'package:cloud_firestore/cloud_firestore.dart';

extension DataList<R> on QuerySnapshot<R> {
  List<R> data() => docs.map((doc) => doc.data()).toList();
}

extension DataStream<R> on Stream<DocumentSnapshot<R>> {
  Stream<R?> data() => map((doc) => doc.data());
}

extension DataStream2<R> on Stream<List<DocumentSnapshot<R?>>> {
  Stream<List<R>> data() =>
      map((docs) => docs.map((doc) => doc.data()!).toList());
}

extension DataStream3<R> on Stream<QuerySnapshot<R?>> {
  Stream<List<R>> data() => map((doc) => doc.data().cast<R>());
}
