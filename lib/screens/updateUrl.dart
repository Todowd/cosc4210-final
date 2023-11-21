//firebase imports
import 'package:cosc4210final/main.dart';
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
  String owner="";
  String short="";
  String long="";
  String itmId="";
  BuildContext c;

  //constructor
  UpdateUrl({super.key, required this.c, required this.owner, required this.itmId, required this.short, required this.long});

  //product the widget
  Widget build(BuildContext context) {
    //needed directionality
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Update a shortened URL",
      home: UpdateUrlForm(c: c, itmId: itmId, user: owner, short: short, long: long)
    );
  }
  
}

class UpdateUrlForm extends StatelessWidget {
  //text controllers to get text from input fields to use
  TextEditingController longCtrlr=TextEditingController();
  String user="";
  String short="";
  String long="";
  String itmId="";
  BuildContext c;

  //constructor
  UpdateUrlForm({required this.c, required this.itmId, required this.user, required this.short, required this.long}) {
    longCtrlr.text=long;
  }

  void update() async {
    //TODO
    //get authentication
    String currentUser="todowd@uwyo.edu";
    //access firebase DB
//print("long: $long, user: $user, short: $short, itmId: $itmId");
    final db=FirebaseFirestore.instance;
    //Update sure it doesnt exist already
    //bool exists=false;
    //bool notOwner=false; 
    final data=<String, dynamic>{
      "long": longCtrlr.text,
      "owner": user,
      "short": short
    };
    //make query
    await db.collection("urls").doc(itmId).get().then((event) {
      //go through all findings
      //for (var doc in event.docs) {
        //make tmp var to hold data
        var docData;
//print("id: $itmId");
        try {
          docData=event.data() as Map<String, dynamic>;
//print(docData);
        }
        catch(e) {
          Library.message(c, "Doesnt exist!");
print("not the existant!");
          return;
        }
        //have the right one
        //if(docData["short"]==short) {
          if(docData["owner"]!=currentUser) {
print("not the owner!");
            Library.message(c, "Not the owner!");
            return;
            //break;
          }
          if(!Library.isUrl(long)) {
print("not valid!");
            Library.message(c, "Not a valid URL!");
            return;
          }
print(itmId);
docData["long"]=long;
          //exists=true;
          //update the document
          db.collection("urls").doc(itmId).update(data
            /*{
              long: long,
              short: docData["short"],
              owner: docData["owner"]
            }*/
          ).then((value) => print);
print("updated!");
          Navigator.pop(c);
          //break;
        //}
      //}
    });
    /*
    if(!exists) {
//print("escaped loop");
      goto main menu page
      Navigator.push(c, MaterialPageRoute(
        builder: (builder)=>const MyHomePage(title: "URL Shortener")
      ));
      return;
    }
    */
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
              decoration: const InputDecoration(labelText: 'URL to shorten'),
            )
          ),
          //shortened text input
          SizedBox(
            width: 300,
            child: Text('Modify: $short')
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //submit button
              ElevatedButton(
                onPressed: update,
                child: const Text('Update')
              ),
              const SizedBox(width: 15),
              //back button
              ElevatedButton(
                onPressed: () {
                  //Navigator.pop(c);
                  Navigator.pop(c);
                },
                child: const Text('Cancel')
              )
            ]
          )
        ]
      )
    );
  }
}