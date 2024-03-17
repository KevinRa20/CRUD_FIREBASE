import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crud/Services/firestore.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService= FirestoreService();
  //text controller
  final TextEditingController textController= TextEditingController();
  //Abrir un dialogo para abrir una nota 
  void OpenNoteBox(String? docID){
    showDialog(context: context, builder: (context)=> AlertDialog(
      content: TextField(
        controller: textController
      ),
      actions: [ 
        ElevatedButton(onPressed:() {
          //Añadir una nueva nota 
          if(docID== null){
        firestoreService.addNote(textController.text);
         }
         //update an existing note
         else {
          firestoreService.updateNote(docID, textController.text);
         }
          
          
          //clear the text controller
          textController.clear();
          //cerrar la caja
          Navigator.pop(context);
        
        }, child: Text("Add"),
        )
      ],
    ),);
  }

  @override 
Widget build(BuildContext context){
     return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => OpenNoteBox(docID: docID),
        child: const Icon(Icons.add),
        ),
        body:StreamBuilder<QuerySnapshot> (
          stream: firestoreService.getNotesStream(),
          builder: (context , snapshot) {
            //if we have data, get all have the docs 
            if(snapshot.hasData){
              List notesList= snapshot.data!.docs;

              //display as a list 
               return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index){
                  //get each individual doc
                  DocumentSnapshot document = notesList[index ];
                  String docID= document.id;


                  //get note from each doc
                Map<String, dynamic> data= 
                document.data() as Map<String, dynamic>;
                String noteText= data[ 'Notes' ];
                 
                  //display as a list title 
                  return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    //update button 
                    IconButton(onPressed: ()=>OpenNoteBox(docID: docID), 
                    icon: const Icon(Icons.settings),
                    ),
                    //detele button
                    IconButton(onPressed: ()=>firestoreService.deleteNote(docID: docID), 
                    icon: const Icon(Icons.delete),),

                  ],
                  ),

                  );
                  


               });
            }
            //if there is no data
            else{
              return const Text("No notes...");
            }

          },
        ),
     );
}
}