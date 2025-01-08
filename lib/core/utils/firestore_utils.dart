import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>?> getFirestoreDocument({
  required String collectionPath,
  required String documentId,
}) async {
  final firestore = FirebaseFirestore.instance;

  final docSnapshot =
      await firestore.collection(collectionPath).doc(documentId).get();

  if (docSnapshot.exists) {
    print('Document data: ${docSnapshot.data()}');
    return docSnapshot.data();
  } else {
    print('Document does not exist');
    return null;
  }
}
