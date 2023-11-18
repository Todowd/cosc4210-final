//firebase imports
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//flutter visual design imports
import 'package:flutter/material.dart';

//using my library of stuff
import '../library/library.dart';

//page where urls are updated
class UpdateUrl extends StatelessWidget {
  //constructor
  const UpdateUrl({super.key}, String owner, String short, String long);

  //product the widget
  Widget build(BuildContext context) {
    //needed directionality
    return MaterialApp(
      title: "Update a shortened URL",
      home: UpdateUrlForm(ownr: owner, shrt: short, lng: long)
    );
  }
  
}

class UpdateUrlForm extends StatelessWidget {
  //text controllers to get text from input fields to use
  final TextEditingController longCtrlr=TextEditingController();
  final TextEditingController shortCtrlr=TextEditingController();
  String owner;
  String short;
  String long;

  //constructor
  UpdateUrlForm(String ownr, String shrt, String lng) {
    owner=ownr;
    short=shrt;
    long=lng;
    longCtrlr.text=long;
    shortCtrlr.text=short;
  }

  void update() async {
    //TODO
    //get authentication
    //access firebase DB
    final db=FirebaseFirestore.instance;
    var docToUpdate;
    //Update sure it doesnt exist already
    bool exists=false;
    final data=<String, dynamic>{
      "long": long,
      "owner": user,
      "short": short
    };
    await db.collection("urls").get().then((event) {
      for (var doc in event.docs) {
        final docData=doc.data() as Map<String, dynamic>;
//print("${doc.id} => ${doc.data()}");
        if(docData["short"]==shortCtrlr.text) {
//print("already exists");
          exists=true;
          doc.update(data).then((val)=>{
            //TODO
            //updated go back to main menu
          });
          break;
        }
      }
    });
    if(!exists) {
//print("escaped loop");
      //TODO
      //goto main menu page
      return;
    }
    if(!Library.isUrl(long)) {
//print("Bad url!");
      //TODO
      //make user retry
      //give warning
      return;
    }
    db.collection("urls").set(data, SetOptions(merge: true)).then((DocumentReference doc) => {
      //probably go to the main menu portion here
//print('DocumentSnapshot added with ID: ${doc.id}')
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            children: [
              //submit button
              ElevatedButton(
                onPressed: update,
                child: Text('Update')
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