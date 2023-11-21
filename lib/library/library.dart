//just reused functions
import "dart:core";
//flutter visual design imports
import 'package:flutter/material.dart';
//flutter html import, for url redirection
import 'dart:html' as html;

class Library {
  //import Uri for URL stuff
  static bool isUrl(String url) {
    Uri addr;
    try {
      addr=Uri.parse(url);
    } catch(e) {
      return false;
    }
    //trying to do a whole web address check
    if(addr.scheme=='http'||addr.scheme=='https') {
      return true;
    }
    //tried some URL stuff, but trying to keep it simple
    //return url.contains(RegExp(r'www\.[]'));
    return false;
  }

  //Makes the page goto a url
  static void openInWindow(String uri) {
    html.window.open(uri, '_self');
  }

  static Future<void> message(BuildContext context, String msg) {
    //showDialog<E> from flutter material
    return showDialog<void>(
      context: context,
      //requires a builder
      builder: (BuildContext c) {
        return AlertDialog(
          title: Text(msg),
          //main body text
          content: Text("Please retry"),
          actions: <Widget>[
            TextButton(
              //style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: Text('close'),
              onPressed: () {
                //close the popup
                Navigator.of(c).pop();
              }
            )
          ]
        );
      }
    );
  }
}