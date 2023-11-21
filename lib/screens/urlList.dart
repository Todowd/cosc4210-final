//firebase imports
import 'package:cosc4210final/screens/updateUrl.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//flutter visual design imports
import 'package:flutter/material.dart';

//using my library of stuff
import '../library/library.dart';
/*
//eventually add the authentication portion
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
*/

//START AT ListItem/ItemDetails AND THE MODIFY BOTTONS TO RUN UpdateUrl AND MAKE THE STATEFULNESS HAPPEN

//this will be the list of urls and the main menu if you will
class UrlList extends StatelessWidget {
  final BuildContext c;
  const UrlList({super.key, required this.c});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'URL Shortener',
      home: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          decoration: null,
        ),
        child: MyList(c: c)
      )
    );
  }
}








class ListItem extends StatelessWidget {
  final String owner;
  final String short;
  final String long;
  final String itmId;
  BuildContext? c;
  MyListState lst;

  ListItem({required this.c, required this.lst, required this.owner, required this.itmId, required this.long, required this.short});

  void modify() {
    Navigator.push(c!, MaterialPageRoute(
      builder: (context)=>UpdateUrl(
        itmId: itmId,
        owner: owner,
        long: long,
        short: short,
        c: c!
      )
    ));
    lst.updateList();
  }

  void delete() {
    //TODO authenticate to get user
    final db=FirebaseFirestore.instance;
    db.collection("urls").doc(itmId).delete().then(
      (doc)=>{
        lst.updateList()
      },
      onError: (e)=>{
        print("Error: Could not delete url - $e")
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle s=const TextStyle(color: Colors.black, fontSize: 14);
    ElevatedButton? mdfy;
    ElevatedButton? dlt;
    if(itmId!="") {
      c=context;
      mdfy=ElevatedButton(
        onPressed: modify,
        child: const Text('Modify')
      );
      dlt=ElevatedButton(
        onPressed: delete,
        child: const Text('Delete')
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
                const SizedBox(
                  width: 10,
                  height: 50
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: Text(short, style: s)
                ),
                const SizedBox(
                  width: 15,
                  height: 50,
                  child: Text(' | ')
                ),
                const SizedBox(
                  width: 15,
                  height: 50,
                ),
                SizedBox(
                  height: 50,
                  width: 400,
                  child: Text(long, style: s)
                ),
                const SizedBox(
                  width: 10,
                  height: 50
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: mdfy
                ),
                const SizedBox(
                  width: 10,
                  height: 50
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: dlt
                ),
                const SizedBox(
                  width: 10,
                  height: 50
                )
        ],
      ),
    );
  }
}















class MyList extends StatefulWidget {
  BuildContext c;
  MyList({super.key, required this.c}) {

  }

  @override
  State<MyList> createState()=>MyListState(c: c);
}

//I know I know this couldve been a stateful widget, but it was getting complicated,
//and this worked
class MyListState extends State<MyList> {
  List<Widget> lst=List.empty(growable: true);
  //List<String> lst=List.empty(growable: true);
  String user="todowd@uwyo.edu";
  BuildContext c;

  MyListState({required this.c}) {
    updateList();
  }

  Future updateList() async {
    //TODO
    //authenticate to get user
    user="todowd@uwyo.edu";
    //access firebase DB
    final db=FirebaseFirestore.instance;
    //get the list of urls belonging to user
    lst=List.empty(growable: true);
    /*lst.add(
      Container (
        padding: const EdgeInsets.all(50),
        alignment: Alignment.center,
        child:  const SizedBox(
          width: 800,
          height: 100,
          child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 10,
                  height: 50
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: Text(' Shortened')
                ),
                SizedBox(
                  width: 10,
                  height: 50,
                  child: Text(' | ')
                ),
                SizedBox(
                  height: 50,
                  width: 400,
                  child: Text(' Long URL')
                ),
                SizedBox(
                  width: 10,
                  height: 50,
                  child: Text(' | ')
                ),
                SizedBox(
                  width: 10,
                  height: 50
                ),
                SizedBox(
                  width: 150,
                  height: 50
                ),
                SizedBox(
                  width: 10,
                  height: 50
                )
              ],
            )
          )
        )
      )
    );*/
    await db.collection("urls").where("owner", isEqualTo: user).get().then((event) {
      for (var doc in event.docs) {
        final docData=doc.data() as Map<String, dynamic>;
        //lst.add(Row(children: [Text("Item: ${docData["short"]}\n")]));
        //lst.add("Item: ${docData["short"]}\n");
        ListItem itm=ListItem(c: c, lst: this, itmId: doc.id, owner: user, long: docData["long"], short: docData["short"]);
        lst.add(itm);
      }
    });
    setState(() {
      lst=lst;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: lst.length,
        itemBuilder: (BuildContext c, int i) {
          return lst[i];
        }
      )
    );
    /*
    return ListView(
      children: [
        Text("A"),
        Text("B")
      ],
    );*/

    /*return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            Container (
              padding: const EdgeInsets.all(50),
              alignment: Alignment.center,
              child:  const SizedBox(
                width: 800,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                      height: 50
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: Text(' Shortened')
                    ),
                    SizedBox(
                      width: 10,
                      height: 50,
                      child: Text(' | ')
                    ),
                    SizedBox(
                      height: 50,
                      width: 400,
                      child: Text(' Long URL')
                    ),
                    SizedBox(
                      width: 10,
                      height: 50,
                      child: Text(' | ')
                    ),
                    SizedBox(
                      width: 10,
                      height: 50
                    ),
                    SizedBox(
                      width: 150,
                      height: 50
                    ),
                    SizedBox(
                      width: 10,
                      height: 50
                    )
                  ],
                )
              )
            ),
            */
            SafeArea(
              child: ListView(
                children: [
                  Text("A"),
                  Text()
                ]
              )
              /*
               child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext c, int i) {
                  return Text("$i");
                }
               )*/
            )
          ]
        )
      )
    );*/
  }
}
/*
class ListItem extends StatelessWidget {
  String owner="";
  String long="";
  String short="";
  String itmId="";
  
  ListItem({super.key, required this. itmId, required this.long, required this.short, required this.owner}) {}

  void delete() {
    //TODO authenticate to get user
    final db=FirebaseFirestore.instance;
    db.collection("urls").doc(itmId).delete().then(
      (doc)=>{
        //lst!.updateList()
        //TODO
        //GOTO MAIN PAGE AGAIN, like a refresh
      },
      onError: (e)=>{
        print("Error: Could not delete url - $e")
      }
    );
  }

  void tmp() {
    //TOOD
    //somehow get to the updateUrl.dart stuff and then make callback to this?
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            width: 10,
            height: 50
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: Text(short)
          ),
          const SizedBox(
            width: 10,
            height: 50,
            child: Text(' | ')
          ),
          SizedBox(
            height: 50,
            width: 400,
            child: Text(long)
          ),
          const SizedBox(
            width: 10,
            height: 50,
            child: Text(' | ')
          ),
          const SizedBox(
            width: 10,
            height: 50
          ),
          SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
              onPressed: tmp,
              child: const Text('Modify')
            )
          ),
          const SizedBox(
            width: 10,
            height: 50
          )
        ],
      )
    );
  }
}
*/