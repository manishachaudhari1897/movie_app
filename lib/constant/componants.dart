import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/constant/app_fonst.dart';
import 'package:movie_app/constant/app_text.dart';

Future<bool> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    showSnackBar(msgCheckConnection);
    return false;
  } else {
    return true;
  }
}

Timer? debounce;
void showSnackBar(String message, {Color? bgColor}) {
  if(debounce?.isActive??false)debounce?.cancel();
  debounce=Timer(const Duration(milliseconds: 500), () {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(message,
          style:
          AppText.textRegular.copyWith(color: Colors.white, fontSize: 14.0), textAlign: bgColor == null? TextAlign.start:TextAlign.center ),
      titleText: Container(),
      borderRadius: 4.0,
      backgroundColor: bgColor ?? Colors.black,
      colorText: Theme.of(Get.context!).colorScheme.surface,
      isDismissible: false,
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10.0),
      /*mainButton: TextButton(
      child: Text('Undo'),
      onPressed: () {},
    ),*/
    );
  });

}

Widget getNetworkImageView(String imageURL,
    {double? width, double? height, BoxFit? boxFit, bool isShowLoader = true}) {
  return CachedNetworkImage(
    imageUrl: imageURL,
    fit: boxFit ?? BoxFit.cover,
    progressIndicatorBuilder: (context, url, downloadProgress) => Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      alignment: Alignment.center,
      margin: isShowLoader ? EdgeInsets.zero : EdgeInsets.only(top: 12.0),
      child: CircularProgressIndicator(
        value: downloadProgress.progress,
      ),
    ),
    errorWidget: (context, url, error) => Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: const Icon(Icons.person).marginAll(10.0),
    )
  );
}