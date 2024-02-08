import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
   HomePage({super.key});
   final databaseReference = FirebaseDatabase.instance.ref();

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

///creating collection reference
final CollectionReference todo = FirebaseFirestore.instance.collection('todo');

  TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
///delete data
_delete(docId){
  todo.doc(docId).delete();
}
///save data
_save(){
  final data = {
    'doit':titleController.text};
  todo.add(data);
 }
///adding new data
    _add() {
  showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: TextField(

                controller: titleController,
                decoration: InputDecoration(hintText: 'add task',),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                  _save();
                  titleController.clear();

                  Navigator.pop(context);
                  },
                  child: Text('SAVE'),
                ),
                ElevatedButton(onPressed: () {

                 Navigator.pop(context);
                }, child: Text('Cancel'))
              ],
            );
          });
    }
///updating
    _update(docId){
  final data = {
    'doit':titleController.text
  };
  todo.doc(docId).update(data);
    }

    ///edit data
    _edit(docId,String title) {

  titleController.text=title;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: TextField(

                controller: titleController,
                decoration: InputDecoration(hintText: 'Update task',),
              ),
              actions: [
                ElevatedButton(
                  onPressed: ()  {
                    _update(docId);
                    titleController.clear();
                  },
                  child: Text('UPdate'),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Cancel'))
              ],
            );
          });
    }

    return Scaffold(
      floatingActionButton:
          FloatingActionButton(onPressed: (){ _add(); } , child: Text('Add ')),
      appBar: AppBar(
        title: Text('Todo List '),
        backgroundColor: Colors.greenAccent,
      ),
      body: StreamBuilder(stream: todo.snapshots(),builder: (context, snapshot) {
        if(snapshot.hasData){
          int count = snapshot.data!.size;
          return ListView.builder(itemCount:count ,itemBuilder: (context,index){
            final DocumentSnapshot todoSnap = snapshot.data!.docs[index];
            return Card(
              child:
              ListTile(title:Text(todoSnap['doit']) ,leading: IconButton(icon: Icon(Icons.edit),
                onPressed: (){
                String todotitle = todoSnap['doit'];
                _edit(todoSnap.id,todotitle);
              },),
              trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){
                _delete(todoSnap.id);
              },),)
            );

          });
        }
        return const SizedBox();
      },)
    );
  }
}
/*
ListView.builder(
itemCount: todoList.length,
itemBuilder: (context, index) {
return Card(
child: ListTile(
title: Text(todoList[index].toString()),
leading: IconButton(onPressed: () {
titleController.text = todoList[index].toString();
_edit(index);
}, icon: Icon(Icons.edit)),
trailing: IconButton(icon: const Icon(Icons.delete),onPressed: ()  {
setState(() {
todoList.removeAt(index);
});

},),
),
);
}),*/
