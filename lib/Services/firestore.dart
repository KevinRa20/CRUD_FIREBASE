import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // GET: get collections of notes 
  final CollectionReference notes =FirebaseFirestore.instance.collection('Notes');

  //CREATE: create a new notes
  Future<void> addNote(String note ){
    return notes.add({
      'Notes':note,
      'timestamp':Timestamp.now(),
    });
  }
  //Read:get notes from databases
  Stream<QuerySnapshot> getNotesStream(){
   final notesStream= notes.orderBy('timestamp', descending: true).snapshots();
   return notesStream;
  }
  //Update: update notes given a doc id
  Future<void> updateNote(String docID, String newNote){
    return notes.doc(docID).update({
      'Notes':newNote,
      'timestamp': Timestamp.now(),
    });
  }
  //DELETE: delete notes given a doc id
  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }
}