

/*

//read get the one url that exists then goto it
await db.collection("users").get().then((event) {
  for (var doc in event.docs) {
    print("${doc.id} => ${doc.data()}");
  }
});
 */

 //firebase imports
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//flutter visual design imports
import 'package:flutter/material.dart';

//flutter html import, for url redirection
import 'dart:html' as html;

void openInWindow(String uri, String name) {
  html.window.open(uri, name);
}
print('heading over to... $uri');
openInWindow(uri.toString(), '_self');

//using my library of stuff
import '../library/library.dart';

//the page where you used the shortened url
class GotoUrl extends StatelessWidget {
  //constructor
  const GotoUrl({super.key});

  //product the widget
  Widget build(BuildContext context) {
    //needed directionality
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GoTo a shortened URL",
      home: GotoUrlForm()
    );
  }
  
}

class GotoUrlForm extends StatelessWidget {
  //text controllers to get text from input field to use
  final TextEditingController shortCtrlr=TextEditingController();
  
  //constructor
  GotoUrlForm() {}

  void add() async {
    //TODO
    //get authentication
    String user="todowd@uwyo.edu";
    //get the user given text
    String short=shortCtrlr.text;
    //access firebase DB
    final db=FirebaseFirestore.instance;
    //make sure it doesnt exist already
    bool exists=false;
    await db.collection("urls").get().then((event) {
      for (var doc in event.docs) {
        final docData=doc.data() as Map<String, dynamic>;
        if(docData["short"]==shortCtrlr.text) {
          exists=true;
          //Redirect to that page
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