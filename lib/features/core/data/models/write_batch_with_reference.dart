import 'package:cloud_firestore/cloud_firestore.dart';

class WriteBatchWithReference<T> {
  final WriteBatch writeBatch;
  final DocumentReference<T> documentReference;

  const WriteBatchWithReference({
    required this.writeBatch,
    required this.documentReference,
  });
}
