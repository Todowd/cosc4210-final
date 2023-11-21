

/*

//read get the one url that exists then goto it
await db.collection("users").get().then((event) {
  for (var doc in event.docs) {
    print("${doc.id} => ${doc.data()}");
  }
});
 */

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
      home: GotoUrlForm(context)
    );
  }
  
}

class GotoUrlForm extends StatelessWidget {
  //text controllers to get text from input field to use
  final TextEditingController urlCtrlr=TextEditingController();
  BuildContext? c;
  
  //constructor
  GotoUrlForm(BuildContext context) {
    c=context;
  }

  void goto() async { //I made a goto
    //TODO
    //get authentication
    //String user="todowd@uwyo.edu";
    //get the user given text
    //String short=urlCtrlr.text;
    //access firebase DB
    final db=FirebaseFirestore.instance;
    //make sure it doesnt exist already
    bool exists=false;
    await db.collection("urls").get().then((event) {
      for (var doc in event.docs) {
        final docData=doc.data() as Map<String, dynamic>;
//var tmp=docData["short"];
//print("short: $tmp");
        if(docData["short"]==urlCtrlr.text) {
          exists=true;
          //Redirect to that page
          Library.openInWindow(docData["long"]);
          break;
        }
      }
    });
    if(!exists) {
      Library.message(c!, "URL not found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const Text("goto a URL", style: TextStyle(fontSize: 20)),
          //shortened text input
          SizedBox(
            width: 300,
            child: TextField(
                controller: urlCtrlr,
                decoration: const InputDecoration(labelText: 'Shortened text'),
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
                onPressed: goto,
                child: const Text('goto')
              ),
              const SizedBox(width: 15),
              //back button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (builder)=>const MyHomePage(title: "URL Shortener")
                  ));
                },
                child: const Text('Cancel')
              )
            ]
          )
        ],
      ),
    );
  }
}