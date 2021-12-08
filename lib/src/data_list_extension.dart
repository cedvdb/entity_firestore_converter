import 'package:cloud_firestore/cloud_firestore.dart';

extension DataList<R> on QuerySnapshot<R> {
  List<R> data() => docs.map((doc) => doc.data()).toList();
}
