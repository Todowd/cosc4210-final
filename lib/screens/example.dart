//firebase imports
import 'package:cosc4210final/main.dart';
import 'package:cosc4210final/screens/goto.dart';
import 'package:cosc4210final/screens/urlList.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

//flutter visual design imports
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      //home: const UrlList(),
      home: ExamplePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key, required this.title});
  final String title;

  @override
  State<ExamplePage> createState() => ExamplePageState();
}

class ExamplePageState extends State<ExamplePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void reset() {
    setState(() {
      _counter=0;
    });
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: reset,
               child: const Text("Reset")
            ),
            ElevatedButton(
              onPressed: () {
                //Navigator.pop(c);
                Navigator.push(context, MaterialPageRoute(
                  builder: (builder)=>const MyHomePage(title: "URL Shortener")
                ));
              },
               child: const Text("Home")
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      )
    );
  }
}
