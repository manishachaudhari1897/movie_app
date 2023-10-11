import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  static String baseUrl = "https://api.themoviedb.org/3/";
  static const imageBaseURL = "https://api.themoviedb.org/3";


  static const success = 200;
  static const unauthorised = 403;

  static const userInactivate = 401;
  static const userDeleted = 402;

  static const popular = "movie/popular?language=en-US&page=";
  static const topRated = "movie/top_rated?language=en-US&page=";
  static const upComing = "movie/upcoming?language=en-US&page=";
  static const genreList = "genre/movie/list?language=en";

  // static var httpClient = http.Client();

  static Future<Map<String, dynamic>?> callGetApi(String endPoint, Function? onError) async {
    var token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMTI5OWE4ZGRkMDdiN2QwYmU3ZjBiMjM1YTk5NWFjMyIsInN1YiI6IjY1MjU1ODhmMDcyMTY2NDViNmRhN2FmNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Xx5zaMl3v8GYgQgwvcWhyrsb861SgAe3SFdNFkFqmic";
    Map<String, String> header = <String, String>{};
    header.addAll({
      'Accept': 'application/json',
    });
    if (token != null) {
      header.addAll({
        'Authorization': 'Bearer $token',
      });
    }
    print("ApiService GET Api: ${baseUrl + endPoint}");
    print("ApiService Api Header: $header");

    var response = await http.get(Uri.parse(baseUrl + endPoint), headers: header);

    print("ApiService GET Response Code : ${response.statusCode} of ${endPoint}");
    print("ApiService GET Response : ${json.decode(response.body)}");
    if (response.statusCode == success) {
      return jsonDecode(response.body);
    } else if (response.statusCode == unauthorised) {
      //TODO : Expired Login
      print("ApiService Post Response Code : ${response.statusCode}");
      if (onError != null) {
        onError();
        print("object only unautherrized get");

      } else {

      }
      return null;
    }
    else if (response.statusCode == userInactivate) {
      print("ApiService Post Response Code : ${response.statusCode}");
      if (onError != null) {
        onError();

      } else {
        print("ApiService Post Response Code : ${response.statusCode}");

      }
      return null;
    }
    else if (response.statusCode == userDeleted) {
      print("ApiService Post Response Code : ${response.statusCode}");
      if (onError != null) {
        onError();
      } else {
        print("ApiService Post Response Code : ${response.statusCode}");
      }
      return null;
    }
    else if (response.statusCode == 400 || response.statusCode == 403 || response.statusCode == 500) {
    } else {
      print("ApiService Post Response Code Error : ${response.statusCode}");
      if (onError != null) {
        onError();
      } else {

      }
      return null;
    }
  }

  /*static Future<Map<String, dynamic>?> callPostApi(String endPoint, Object params, Function? onError) async {
    var token = await StorageUtil.getData(StorageUtil.keyToken);

    var languageCode = await StorageUtil.getData(StorageUtil.keyLanguageCode);

    Map<String, String> header = <String, String>{};
    header.addAll({'Accept': 'application/json', 'Content-Type': 'application/json'});
    if (token != null) {
      header.addAll({
        'Authorization': 'Bearer $token',
      });
    }
    print("ApiService Post Api: ${BASE_URL + endPoint}");
    print("ApiService Api Header: $header");
    print("ApiService Api Params: $params");

    var response = await http.post(Uri.parse(BASE_URL + endPoint), headers: header, body: params);

    print("ApiService Post Response Code : ${response.statusCode}");
    print("ApiService Post Response : ${json.decode(response.body)}");
    if (response.statusCode == SUCCESS) {
      return jsonDecode(response.body);
    } else if (response.statusCode == UNAUTHORISED) {
      //TODO : Expired Login
      print("ApiService Post Response Code : ${response.statusCode}");
      if (onError != null) {
        onError();
        print("object only unautherrized ");
        forceLogoutDialog(lblSessionExpired, msgSessionExpiredMsg, Get.context!);
       *//* WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            detachedCallBack: () {
              print('detached...111');
              forceLogoutApiCall();
            },
            resumeCallBack: () async {
              print('detached...111');
              print('resume...');
            }));*//*
      } else {
        openAndCloseLoadingDialog(false);
        forceLogoutDialog(lblSessionExpired, msgSessionExpiredMsg, Get.context!);
        WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            detachedCallBack: () {
              forceLogoutApiCall();
            },
            resumeCallBack: () async {
              print('resume...');
            }));
      }
      return null;
    }
    else if (response.statusCode == userInactivate) {
      print("ApiService Post Response Code : ${response.statusCode}");
      if (onError != null) {
        onError();
        forceLogoutDialog(lblSessionExpired, lblUserInactivated, Get.context!);
        WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            detachedCallBack: () {
              print('detached...111');
              forceLogoutApiCall();
            },
            resumeCallBack: () async {
              print('resume...');
            }));
      } else {
        print("ApiService Post Response Code : ${response.statusCode}");
        openAndCloseLoadingDialog(false);
        forceLogoutDialog(lblSessionExpired, lblUserInactivated, Get.context!);
        WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            detachedCallBack: () {
              print('detached...111');
              forceLogoutApiCall();
            },
            resumeCallBack: () async {
              print('resume...');
            }));
      }
      return null;
    }
    else if (response.statusCode == userDeleted) {
      print("ApiService Post Response Code : ${response.statusCode}");
      if (onError != null) {
        onError();
        forceLogoutDialog(lblSessionExpired, lblUserDeleted, Get.context!);
        WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            detachedCallBack: () {
              print('detached...111');
              forceLogoutApiCall();
            },
            resumeCallBack: () async {
              print('resume...');
            }));
      } else {
        print("ApiService Post Response Code : ${response.statusCode}");
        openAndCloseLoadingDialog(false);
        forceLogoutDialog(lblSessionExpired, lblUserDeleted, Get.context!);
        WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            detachedCallBack: () {
              print('detached...111');
              forceLogoutApiCall();
            },
            resumeCallBack: () async {
              print('resume...');
            }));
      }
      return null;
    }
    else if (response.statusCode == 400 || response.statusCode == 403 || response.statusCode == 500) {
      showSnackBar(msgSomethingWentWrong);
    }
    else {
      if (onError != null) {
        onError();
      } else {
        openAndCloseLoadingDialog(false);
        showSnackBar(msgSomethingWentWrong);
        forceLogoutApiCall();
        print("forceLogoutApiCall()");
      }
      return null;
    }
  }*/

}