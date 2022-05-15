import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_template/strings/generated/l10n.dart';
import 'package:loglytics/loglytics.dart';
import '../data/enums/feedback_type.dart';
import '../data/responses/service_response.dart';
import 'fa_message_config.dart';

typedef FirestoreQuery<T> = Query<T> Function(CollectionReference<T> collectionReference);

class FirestoreApi<T extends Object> with Loglytics {
  FirestoreApi({
    required FirebaseFirestore firebaseFirestore,
    required String collectionPath,
    Map<String, dynamic> Function<T>(T value)? toJson,
    T Function<T>(Map<String, dynamic> json)? fromJson,
    FeedbackMessageConfig feedbackMessageConfig = const FeedbackMessageConfig(),
  })  : _firebaseFirestore = firebaseFirestore,
        _collectionPath = collectionPath,
        _toJson = toJson,
        _fromJson = fromJson,
        _feedbackMessageConfig = feedbackMessageConfig;

  final FirebaseFirestore _firebaseFirestore;
  final String _collectionPath;
  final Map<String, dynamic> Function<T>(T value)? _toJson;
  final T Function<T>(Map<String, dynamic> json)? _fromJson;
  final FeedbackMessageConfig _feedbackMessageConfig;

  // TODO(Brian): Add isValid checks | feature/MAF-1228-subscription-checklist | 18/03/2022

  Future<ServiceResponse<Map<String, dynamic>>> findById({
    required String id,
  }) async {
    try {
      final data = (await findDocRef(id: id).get()).data();
      if (data != null) {
        return ServiceResponse.success(result: data);
      } else {
        return _readFailedResponse(isPlural: false);
      }
    } catch (error, stackTrace) {
      log.error(
        'Unable to find $_collectionPath document per id: $id',
        error: error,
        stackTrace: stackTrace,
      );
      return _readFailedResponse(isPlural: false);
    }
  }

  Future<ServiceResponse<T>> findByIdWithConverter({
    required String id,
  }) async {
    try {
      final data = (await findDocRefWithConverter(id: id).get()).data();
      if (data != null) {
        return ServiceResponse.success(
          result: data,
          feedbackType: FeedbackType.none,
        );
      } else {
        return _readFailedResponse<T>(isPlural: false);
      }
    } catch (error, stackTrace) {
      log.error('Unable to find $_collectionPath document per id: $id',
          error: error, stackTrace: stackTrace);
      return _readFailedResponse<T>(isPlural: false);
    }
  }

  Future<ServiceResponse<List<Map<String, dynamic>>>> findBySearchTerm({
    required String searchTerm,
    required String fieldName,
    required bool isArray,
    int? limit,
  }) async {
    try {
      final dataList = (await (isArray
                  ? limit == null
                      ? findCollection().where(fieldName,
                          arrayContainsAny: [searchTerm, ...searchTerm.split(' ')])
                      : findCollection().where(fieldName,
                          arrayContainsAny: [searchTerm, ...searchTerm.split(' ')]).limit(limit)
                  : limit == null
                      ? findCollection().where(
                          fieldName,
                          isEqualTo: searchTerm,
                        )
                      : findCollection()
                          .where(
                            fieldName,
                            isEqualTo: searchTerm,
                          )
                          .limit(limit))
              .get())
          .docs
          .map((e) => e.data())
          .toList();
      return ServiceResponse.success(
        result: dataList,
        feedbackType: FeedbackType.none,
      );
    } catch (error, stackTrace) {
      log.error(
        'Unable to find $_collectionPath documents per '
        'search term: $searchTerm and '
        'field: $fieldName',
        error: error,
        stackTrace: stackTrace,
      );
      return _readFailedResponse(isPlural: true);
    }
  }

  Future<ServiceResponse<List<T>>> findBySearchTermWithConverter({
    required String searchTerm,
    required String fieldName,
    required bool isArray,
    int? limit,
  }) async {
    try {
      final dataList = (await (isArray
                  ? limit == null
                      ? findCollectionWithConverter().where(fieldName,
                          arrayContainsAny: [searchTerm, ...searchTerm.split(' ')])
                      : findCollectionWithConverter().where(fieldName,
                          arrayContainsAny: [searchTerm, ...searchTerm.split(' ')]).limit(limit)
                  : limit == null
                      ? findCollectionWithConverter().where(
                          fieldName,
                          isEqualTo: searchTerm,
                        )
                      : findCollectionWithConverter()
                          .where(
                            fieldName,
                            isEqualTo: searchTerm,
                          )
                          .limit(limit))
              .get())
          .docs
          .map((e) => e.data())
          .toList();
      return ServiceResponse.success(
        result: dataList,
        feedbackType: FeedbackType.none,
      );
    } catch (error, stackTrace) {
      log.error(
        'Unable to find $_collectionPath documents per '
        'search term: $searchTerm and '
        'field: $fieldName',
        error: error,
        stackTrace: stackTrace,
      );
      return _readFailedResponse(isPlural: true);
    }
  }

  Future<ServiceResponse> findByQuery({
    required FirestoreQuery firestoreQuery,
  }) async {
    try {
      final data =
          (await firestoreQuery(findCollection()).get()).docs.map((e) => e.data()).toList();
      return ServiceResponse.success(
        result: data,
        feedbackType: FeedbackType.none,
      );
    } catch (error, stackTrace) {
      log.error('Unable to find $_collectionPath documents per custom query',
          error: error, stackTrace: stackTrace);
      final unit = _firestoreCollectionType.unit(2);
      return ServiceResponse.error(
          title: Strings.current.searchFailed, message: Strings.current.searchFailedMessage(unit));
    }
  }

  Future<ServiceResponse<List<T>>> findByQueryWithConverter({
    required FirestoreQuery<T> firestoreQuery,
  }) async {
    try {
      final dtos = (await firestoreQuery(findCollectionWithConverter()).get())
          .docs
          .map((e) => e.data())
          .toList();
      return ServiceResponse.success(result: dtos);
    } catch (error, stackTrace) {
      log.error('Unable to find $_collectionPath documents per custom query',
          error: error, stackTrace: stackTrace);
      final unit = _firestoreCollectionType.unit(2);
      return ServiceResponse.error(
          title: Strings.current.searchFailed, message: Strings.current.searchFailedMessage(unit));
    }
  }

  Future<ServiceResponse> findAll() async {
    try {
      final dtos = (await findCollection().get()).docs.map((e) => e.data()).toList();
      return ServiceResponse.success(result: dtos);
    } catch (error, stackTrace) {
      log.error('Unable to find $_collectionPath all documents per findAll query',
          error: error, stackTrace: stackTrace);
      final unit = _firestoreCollectionType.unit(2);
      return ServiceResponse.error(
          title: Strings.current.searchFailed, message: Strings.current.searchFailedMessage(unit));
    }
  }

  Future<ServiceResponse<List<T>>> findAllWithConverter() async {
    try {
      final dtos = (await findCollectionWithConverter().get()).docs.map((e) => e.data()).toList();
      return ServiceResponse.success(result: dtos);
    } catch (error, stackTrace) {
      log.error('Unable to find $_collectionPath all documents per findAll query',
          error: error, stackTrace: stackTrace);
      final unit = _firestoreCollectionType.unit(2);
      return ServiceResponse.error(
          title: Strings.current.searchFailed, message: Strings.current.searchFailedMessage(unit));
    }
  }

  ServiceResponse<E> _readFailedResponse<E>({
    required isPlural,
  }) =>
      ServiceResponse.error(
        title: _feedbackMessageConfig.searchFailedTitle,
        message: isPlural
            ? _feedbackMessageConfig.pluralReadFailedMessage
            : _feedbackMessageConfig.singularReadFailedMessage,
      );

  Future<ServiceResponse<DocumentReference>> create({
    required Writeable writeable,
    String? id,
    WriteBatch? writeBatch,
    TimestampType createTimeStampType = TimestampType.createdAndUpdated,
    TimestampType updateTimeStampType = TimestampType.updated,
    bool addIdAsField = false,
    bool merge = false,
    List<FieldPath>? mergeFields,
  }) async {
    try {
      final DocumentReference documentReference;
      if (writeBatch != null) {
        final lastBatch = await batchCreate(
          writeable: writeable,
          id: id,
          writeBatch: writeBatch,
          createTimeStampType: createTimeStampType,
          updateTimeStampType: updateTimeStampType,
          addIdAsField: addIdAsField,
        );
        if (lastBatch != null) {
          await lastBatch.writeBatch.commit();
          documentReference = lastBatch.documentReference;
        } else {
          throw BatchFailedException(
            fireCollectionType: _firestoreCollectionType,
            id: id,
            crudType: CrudType.create,
          );
        }
      } else {
        documentReference = id != null ? findDocRef(id: id) : findCollection().doc();
        final writeableToJson =
            (merge || mergeFields != null) && (await documentReference.get()).exists
                ? updateTimeStampType.add(writeable.toJson())
                : createTimeStampType.add(
                    writeable.toJson(),
                  );
        if (addIdAsField) writeableToJson.withId(documentReference.id);
        await documentReference.set(
          writeableToJson,
          SetOptions(
            merge: mergeFields == null ? merge : null,
            mergeFields: mergeFields,
          ),
        );
      }
      return ServiceResponse.success(result: documentReference);
    } catch (error, stackTrace) {
      log.error('Unable to create $_collectionPath document', error: error, stackTrace: stackTrace);
      return ServiceResponse.error(
          title: Strings.current.crudCreateFailed,
          message: Strings.current
              .crudCreateFailedMessage(_firestoreCollectionType.unit(writeBatch != null ? 2 : 1)));
    }
  }

  Future<WriteBatchWithReference?> batchCreate({
    required Writeable writeable,
    String? id,
    WriteBatch? writeBatch,
    TimestampType createTimeStampType = TimestampType.createdAndUpdated,
    TimestampType updateTimeStampType = TimestampType.updated,
    bool addIdAsField = false,
    bool merge = false,
    List<FieldPath>? mergeFields,
  }) async {
    try {
      final _writeBatch = writeBatch ?? _firebaseFirestore.batch();
      final documentReference = id != null ? findDocRef(id: id) : findCollection().doc();
      final writeableAsJson =
          (merge || mergeFields != null) && (await documentReference.get()).exists
              ? updateTimeStampType.add(writeable.toJson())
              : createTimeStampType.add(
                  writeable.toJson(),
                );
      if (addIdAsField) writeableAsJson.withId(documentReference.id);
      _writeBatch.set(
        documentReference,
        writeableAsJson,
        SetOptions(
          merge: mergeFields == null ? merge : null,
          mergeFields: mergeFields,
        ),
      );
      return WriteBatchWithReference(writeBatch: _writeBatch, documentReference: documentReference);
    } catch (error, stackTrace) {
      log.error(
        'Unable to batch create $_collectionPath with id: $id',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<ServiceResponse<DocumentReference>> update({
    required Writeable writeable,
    required String id,
    WriteBatch? writeBatch,
    TimestampType timestampType = TimestampType.updated,
  }) async {
    try {
      final DocumentReference documentReference;
      if (writeBatch != null) {
        final lastBatch = await batchUpdate(
          writeable: writeable,
          id: id,
          writeBatch: writeBatch,
          timestampType: timestampType,
        );
        if (lastBatch != null) {
          await lastBatch.writeBatch.commit();
          documentReference = lastBatch.documentReference;
        } else {
          throw BatchFailedException(
            fireCollectionType: _firestoreCollectionType,
            id: id,
            crudType: CrudType.update,
          );
        }
      } else {
        documentReference = findDocRef(id: id);
        await documentReference.update(timestampType.add(writeable.toJson()));
      }
      return ServiceResponse.success(result: documentReference);
    } catch (error, stackTrace) {
      log.error('Unable to update $_collectionPath document', error: error, stackTrace: stackTrace);
      return ServiceResponse.error(
          title: Strings.current.crudUpdateFailed,
          message: Strings.current
              .crudUpdateFailedMessage(_firestoreCollectionType.unit(writeBatch != null ? 2 : 1)));
    }
  }

  Future<WriteBatchWithReference?> batchUpdate({
    required Writeable writeable,
    required String id,
    WriteBatch? writeBatch,
    TimestampType timestampType = TimestampType.updated,
  }) async {
    try {
      final _writeBatch = writeBatch ?? _firebaseFirestore.batch();
      final documentReference = findDocRef(id: id);
      _writeBatch.update(
        documentReference,
        timestampType.add(
          writeable.toJson(),
        ),
      );
      return WriteBatchWithReference(
        writeBatch: _writeBatch,
        documentReference: documentReference,
      );
    } catch (error, stackTrace) {
      log.error(
        'Unable to batch update $_collectionPath with id: $id',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<ServiceResponse<DocumentReference>> delete({
    required String id,
    WriteBatch? writeBatch,
  }) async {
    try {
      final DocumentReference documentReference;
      if (writeBatch != null) {
        final lastBatch = await batchDelete(id: id, writeBatch: writeBatch);
        if (lastBatch != null) {
          await lastBatch.writeBatch.commit();
          documentReference = lastBatch.documentReference;
        } else {
          throw BatchFailedException(
            fireCollectionType: _firestoreCollectionType,
            id: id,
            crudType: CrudType.delete,
          );
        }
      } else {
        documentReference = findDocRef(id: id);
        await documentReference.delete();
      }
      return ServiceResponse.success(result: documentReference);
    } catch (error, stackTrace) {
      log.error('Unable to update $_collectionPath document', error: error, stackTrace: stackTrace);
      return ServiceResponse.error(
          title: Strings.current.crudDeleteFailed,
          message: Strings.current
              .crudDeleteFailedMessage(_firestoreCollectionType.unit(writeBatch != null ? 2 : 1)));
    }
  }

  Future<WriteBatchWithReference?> batchDelete({
    required String id,
    WriteBatch? writeBatch,
  }) async {
    try {
      final _writeBatch = writeBatch ?? _firebaseFirestore.batch();
      final documentReference = findDocRef(id: id);
      _writeBatch.delete(documentReference);
      return WriteBatchWithReference(
        writeBatch: _writeBatch,
        documentReference: documentReference,
      );
    } catch (error, stackTrace) {
      log.error(
        'Unable to batch delete $_collectionPath with id: $id',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  CollectionReference<T> findCollectionWithConverter() =>
      _firebaseFirestore.collection(_collectionPath).withConverter<T>(
            fromFirestore: (snapshot, options) =>
                _fromJson!(snapshot.data()!.tryWithId(snapshot.id)),
            toFirestore: (value, options) => _toJson!(value),
          );

  DocumentReference<T> findDocRefWithConverter({
    required String id,
  }) =>
      _firebaseFirestore.doc('$_collectionPath/$id').withConverter<T>(
            fromFirestore: (snapshot, options) => _fromJson!(snapshot.data()!.tryWithId(id)),
            toFirestore: (value, options) => _toJson!(value),
          );

  Future<DocumentSnapshot<T>> findDocSnapshotWithConverter({
    required String id,
  }) async =>
      findDocRefWithConverter(id: id).get();

  Stream findStreamByQuery({
    required FirestoreQuery firestoreQuery,
  }) =>
      firestoreQuery(findCollection()).snapshots().map(
            (event) => event.docs.map((e) => e.data()).toList(),
          );

  Stream<List<T>> findStreamByQueryWithConverter({
    required FirestoreQuery<T> firestoreQuery,
  }) =>
      firestoreQuery(findCollectionWithConverter()).snapshots().map(
            (event) => event.docs.map((e) => e.data()).toList(),
          );

  Stream<List<T>> findStreamWithConverter() => findCollectionWithConverter()
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());

  Stream<T?> findDocStreamWithConverter({required String id}) =>
      findDocRefWithConverter(id: id).snapshots().map((e) => e.data());

  CollectionReference<Map<String, dynamic>> findCollection() =>
      _firebaseFirestore.collection(_collectionPath);

  DocumentReference<Map<String, dynamic>> findDocRef({
    required String id,
  }) =>
      _firebaseFirestore.doc('$_collectionPath/$id');

  Future<DocumentSnapshot<Map<String, dynamic>>> findDocSnapshot({
    required String id,
  }) async =>
      findDocRef(id: id).get();

  Stream<QuerySnapshot<Map<String, dynamic>>> findStream() => findCollection().snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> findDocStream({required String id}) =>
      findDocRef(id: id).snapshots();

  Future<bool> docExists({required String id}) async => (await findDocRef(id: id).get()).exists;
}
