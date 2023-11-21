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

//page where urls are made
class MakeUrl extends StatelessWidget {
  final BuildContext c;
  //constructor
  const MakeUrl({super.key, required this.c});

  //product the widget
  Widget build(BuildContext context) {
    //needed directionality
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Make a shortened URL",
      home: MakeUrlForm(c: c)
    );
  }
  
}

class MakeUrlForm extends StatelessWidget {
  //text controllers to get text from input fields to use
  final TextEditingController longCtrlr=TextEditingController();
  final TextEditingController shortCtrlr=TextEditingController();
  final BuildContext c;

  //constructor
  MakeUrlForm({super.key, required this.c}) {
  }

  void add() async {
//print("add fn called");
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
//print("exists");
          exists=true;
          break;
        }
      }
    });
    if(exists) {
//print("escaped loop");
      Library.message(c, "Already exists!");
      return;
    }
    if(!Library.isUrl(long)) {
//print("Bad url!");
      Library.message(c, "Bad URL!");
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
      shortCtrlr.text="";
      longCtrlr.text="";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: AppBar(
        title: const Text("Make a new shortened URL"),
      ),*/
      appBar: AppBar(
        title: const Text("goto a URL"),
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyApp()));
          },
          icon: const Icon(Icons.arrow_back)
        )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Add a URL", style: TextStyle(fontSize: 20)),
          //shortened text input
          SizedBox(
            width: 300,
            child: TextField(
                controller: shortCtrlr,
                decoration: const InputDecoration(labelText: 'Shortened text'),
              )
          ),
          //Long URL to shorten
          SizedBox(
            width: 300,
            child: TextField(
              controller: longCtrlr,
              decoration: const InputDecoration(labelText: 'URL to shorten'),
            )
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //TODO
            //make each button slightly bigger, and put space between
            children: [
              //submit button
              ElevatedButton(
                onPressed: add,
                child: const Text('Add')
              ),
              const SizedBox(width: 15),
              //Text(" "),
              //back button
              ElevatedButton(
                onPressed: () {
                  //Navigator.pop(c);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (builder)=>const MyHomePage(title: "URL Shortener")
                  ));
                },
                child: const Text('Home')
              )
            ]
          )
        ]
      )
    );
  }
}