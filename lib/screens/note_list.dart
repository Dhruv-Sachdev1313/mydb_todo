import 'package:flutter/material.dart';
import 'dart:async';
import '../database_helper.dart';
import '../Note.dart';
import 'package:sqflite/sqflite.dart';
import 'note_details.dart';


class NoteList extends StatefulWidget {
  @override
   _NoteListState createState() => _NoteListState();
}
class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> notelist;
  int count = 0;

   @override
   Widget build(BuildContext context) {
     if (notelist == null) {
       notelist = List<Note>();
       updateListView();
       
     }
    return Scaffold(
      appBar: AppBar(
        title: Text('My ToDo'),
        backgroundColor: Colors.purple,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton( 
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        onPressed: () {
          navigateTODetail(Note('','',2), 'Add Note');
        }, 
      ),
       
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, position) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.purple,
          elevation: 4.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("https://learncodeonline.in/mascot.png"),
            ),
            title: Text(this.notelist[position].title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
            subtitle: Text(this.notelist[position].date,
              style: TextStyle(
                color: Colors.white
              ),
            ),
            trailing: GestureDetector(
              child: Icon(Icons.open_in_new, color: Colors.white),
              onTap: () {
                navigateTODetail(this.notelist[position], 'Edit Todo');
              }
            ),
          ),
        );
      }
    );
  }
  void navigateTODetail(Note note,String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(note,title);
    }));

    if(result == true) {
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.notelist = noteList;
          this.count = noteList.length;
        });
        
      });
    } );

  }
} 