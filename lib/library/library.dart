//just reused functions
import "dart:core";

class Library {
  //import Uri for URL stuff
  static bool isUrl(String url) {
    Uri addr;
    try {
      addr=Uri.parse(url);
    } catch(e) {
      return false;
    }
    if(addr.scheme=='http'||addr.scheme=='https') {
      return true;
    }
    //tried some URL stuff, but trying to keep it simple
    //return url.contains(RegExp(r'www\.[]'));
    return false;
  }
}