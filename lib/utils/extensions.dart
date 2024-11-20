import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:citypressgo/config.dart';

import '../models/vklm.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}



Future<bool> isNetworkConnection() async {
  var connectivityResult = await Connectivity()
      .checkConnectivity(); //Check For Wifi or Mobile data is ON/OFF
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    final result = await InternetAddress.lookup(
        'google.com'); //Check For Internet Connection
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

happens(on){
  bool isDash = false;
  if (on.message.toString().contains(k64(appFonts.mi1)) ||
      on.message.toString().contains(k64(appFonts.md2)) ||
      on.message.toString().contains(k64(appFonts.mp3)) ||
      on.message.toString().contains(k64(appFonts.mis4))) {
    isDash = true;
    //flutterAlertMessage(msg: on.message);
    return isDash;
  } else {
    if (on.toString().contains(k64(appFonts.mCU5))) {
      isDash = false;
      return isDash;

    } else {
      isDash = false;
      return isDash;
    }
  }
}

flutterAlertMessage ({msg,bgColor}) {
 /* Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor ?? appCtrl.appTheme.redColor,
      textColor: appCtrl.appTheme.sameWhite,
      fontSize: Sizes.s16
  );*/
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text(msg,style: GoogleFonts.outfit(color: appCtrl.appTheme.white),)));
}