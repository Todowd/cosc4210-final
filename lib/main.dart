//firebase imports
import 'package:cosc4210final/screens/example.dart';
import 'package:cosc4210final/screens/goto.dart';
import 'package:cosc4210final/screens/urlList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

//flutter visual design imports
import 'package:flutter/material.dart';

//login page
import 'screens/login.dart';
//make url page
import 'screens/makeUrl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //TODO
  //get authorization to work
  /*
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user==null) {
      runApp(const Login());
    } else {
      runApp(const MyApp());
    }
  });
  */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListView (
            children: <Widget>[
              const Text("URL Shortener"),
              const Divider(
                color: Colors.blue
              ),
              ListTile(
                title: const Text("Main Menu"),
                leading: const Icon(Icons.home, color: Colors.black),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
                }
              ),
              ListTile(
                title: const Text('Make new short URL'),
                leading: const Icon(Icons.control_point_rounded, color: Colors.black),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>MakeUrl(c: context))
                  );
                }
              ),
              ListTile(
                title: const Text('Goto URL'),
                leading: const Icon(Icons.open_in_new, color: Colors.black),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>GotoUrl()));
                }
              ),
              ListTile(
                title: const Text('State Example'),
                leading: const Icon(Icons.help, color: Colors.black),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>const Example()
                  ));
                }
              ),
              const Divider(
                color: Colors.blue
              ),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout, color: Colors.black),

              )
            ]
          )
        )
      ),
      body: UrlList(c: context)
    );
  }
}
