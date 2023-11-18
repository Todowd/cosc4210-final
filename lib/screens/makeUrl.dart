//firebase imports
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//flutter visual design imports
import 'package:flutter/material.dart';

//using my library of stuff
import '../library/library.dart';

//page where urls are made
class MakeUrl extends StatelessWidget {
  //constructor
  const MakeUrl({super.key});

  //product the widget
  Widget build(BuildContext context) {
    //needed directionality
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Make a shortened URL",
      home: MakeUrlForm()
    );
  }
  
}

class MakeUrlForm extends StatelessWidget {
  //text controllers to get text from input fields to use
  final TextEditingController longCtrlr=TextEditingController();
  final TextEditingController shortCtrlr=TextEditingController();
  
  //constructor
  makeUrlForm() {}

  void add() async {
    //TODO
    //get authentication
    String user="todowd@uwyo.edu";
    //get the user given text
    String long=longCtrlr.text;
    String short=shortCtrlr.text;
    //access firebase DB
    final db=FirebaseFirestore.instance;
    //make sure it doesnt exist already
    bool exists=false;
    await db.collection("urls").get().then((event) {
      for (var doc in event.docs) {
        final docData=doc.data() as Map<String, dynamic>;
//print("${doc.id} => ${doc.data()}");
        if(docData["short"]==shortCtrlr.text) {
//print("already exists");
          exists=true;
          break;
        }
      }
    });
    if(exists) {
//print("escaped loop");
      return;
    }
    if(!Library.isUrl(long)) {
//print("Bad url!");
      //TODO
      //Give warning and make them redo
      return;
    }
    final data=<String, dynamic>{
      "long": long,
      "owner": user,
      "short": short
    };
    db.collection("urls").add(data).then((DocumentReference doc) => {
      //probably go to the main menu portion here
//print('DocumentSnapshot added with ID: ${doc.id}')
    });
    
  }

  void goBack() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Add a URL", style: TextStyle(fontSize: 20)),
          //Long URL to shorten
          SizedBox(
            width: 300,
            child: TextField(
              controller: longCtrlr,
              decoration: InputDecoration(labelText: 'URL to shorten'),
            )
          ),
          //shortened text input
          SizedBox(
            width: 300,
            child: TextField(
                controller: shortCtrlr,
                decoration: InputDecoration(labelText: 'Shortened text'),
              )
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //TODO
            //make each button slightly bigger, and put space between
            children: [
              //submit button
              ElevatedButton(
                onPressed: add,
                child: Text('Add')
              ),
              SizedBox(width: 15),
              //Text(" "),
              //back button
              ElevatedButton(
                onPressed: goBack,
                child: Text('Cancel')
              )
            ]
          )
        ],
      ),
    );
  }
}