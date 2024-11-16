import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final FirestoreService firebaseFirestore = FirestoreService();
  final TextEditingController controller = TextEditingController();

  void openNoteBook({String? docId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter your note'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docId == null) {
                // Add new note
                firebaseFirestore.addNote(controller.text);
              } else {
                // Update existing note
                firebaseFirestore.updateNote(docId, controller.text);
              }
              controller.clear();
              Navigator.pop(context);
            },
            child: Text(docId == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBook(), // Pass a parameterless closure
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseFirestore.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> noteList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = noteList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => openNoteBook(docId: docId), // Pass docId
                        icon: Icon(Icons.settings),
                      ),
                      IconButton(onPressed: ()=>firebaseFirestore.deleteNote(docId), icon: Icon(Icons.delete))
                    ],
                  )
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text("No Data .."));
          }
        },
      ),
    );
  }
}
