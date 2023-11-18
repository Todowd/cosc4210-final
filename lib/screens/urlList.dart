

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
  const UrlList({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'URL Shortener',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyList(),
    );
  }
}

class ListItem extends StatefulWidget {
  String owner;
  String long;
  String short;
  String itmId;

  ListItem({super.key}, String itmid, String o, String l, String s) {
    owner=o;
    long=l;
    short=s;
    itmId=itmid;
  }

  @override
  State<ListItem> createState()=>ItemDetails();
}

class ItemDetails extends State<ListItem> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void tmp() {
    //somehow get to the updateUrl.dart stuff and then make callback to this?
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.left,
        children: <Widget>[
          SizedBox(
            width: 10,
            height: 50
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: Text('$short')
          ),
          SizedBox(
            width: 10,
            height: 50,
            child: Text(' | ')
          ),
          SizedBox(
            height: 50,
            width: 400,
            child: Text('$long')
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
            height: 50,
            child: ElevatedButton(
              onPressed: tmp,
              child: Text('Modify')
            )
          ),
          SizedBox(
            width: 10
            height: 50
          )
        ],
      )
    );
  }
}

class MyList extends StatefulWidget {
  const MyList({super.key});

  @override
  State<MyList> createState()=>MyListState();
}

class MyListState extends State<MyList> {
  List<Widget> lst;
  String user;

  MyListState() {
    updateList();
  }

  void delete(ListItem itm) {
    lst.remove(itm);
    //TODO authenticate to get user
    final db=FirebaseFirestore.instance;
    db.collection("urls").doc(itm.itmId).delete().then(
      (doc)=>{
//print('deleted $itm.id');
        updateList();
      },
      onError: (e)=>{
        print("Error: Could not delete url - $e");
      }
    );
  }

  void updateList() {
    //TODO
    //authenticate to get user
    user="todowd@uwyo.edu";
    //access firebase DB
    final db=FirebaseFirestore.instance;
    //get the list of urls belonging to user
    setState(() {
      lst=List.empty(growable: true);
      await db.collection("urls").where("owner", isEqualTo: user).get().then((event) {
        for (var doc in event.docs) {
          final docData=doc.data() as Map<String, dynamic>;
          ListItem itm=ListItem(itmid: doc.id, o: user, l: docData["long"], s: docData["short"])
          lst.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                itm,
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: delete(itm),
                      child: Text('Delete')
                  )
                )
              ]
            )
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 800,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.left,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                    height: 50
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: Text('Shortened')
                  ),
                  SizedBox(
                    width: 10,
                    height: 50,
                    child: Text(' | ')
                  ),
                  SizedBox(
                    height: 50,
                    width: 400,
                    child: Text('Long URL')
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
                    width: 150
                    height: 50
                  ),
                  SizedBox(
                    width: 10
                    height: 50
                  )
                ],
              )
            );
            ListView(
              padding: const EdgeInsets.all(15);
              children: lst
            )
          ]
        )
      )
    );
  }
}
