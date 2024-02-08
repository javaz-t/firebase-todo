import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

class DataBaseMethods{
  String uuid = Uuid().v4();
  Future<void> addTodo(String task) async {
    return await FirebaseFirestore.instance.collection('todoList').doc().set({
      'task': task,
      // Add other task fields here
    });
  }
  }
