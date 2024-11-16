import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get collection of services
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  //create
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }
  //read
Stream<QuerySnapshot> getNotesStream(){

    final noteStream = notes.orderBy('timestamp',descending: true).snapshots();
    return noteStream;
}
  //update
Future<void> updateNote(String docId,String newNote){
    return notes.doc(docId).update({
      'note':newNote,
      'timestamp':Timestamp.now(),
    });
}
  //Delete
Future<void> deleteNote(String docId){
    return notes.doc(docId).delete();
}
}
