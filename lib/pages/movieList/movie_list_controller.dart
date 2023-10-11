import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/apiservice/api_service.dart';
import 'package:movie_app/constant/componants.dart';
import 'package:movie_app/model/movie_list_model_class.dart';

class MovieListController extends GetxController with GetSingleTickerProviderStateMixin {
  final isApiCall = false.obs;
  final isApiPagination = false.obs;
  final nextPaginationPopularValue = "".obs;
  final popularList = <Results>[].obs;
  final listScrollController = ScrollController().obs;

  final searchEditController = TextEditingController().obs;
  late TabController tabController;
  final showType = "grid".obs;


  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3,initialIndex: 0)
      ..addListener(() {
        searchEditController.value.text = "";
      });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getPopularMovieList();

    listScrollController.value.addListener(() {
      if (listScrollController.value.position.maxScrollExtent ==
          listScrollController.value.position.pixels) {
        if (nextPaginationPopularValue.value.isNotEmpty) {
          print("object=> Scroller Controller reached");
          getPopularMovieList(isPagination: true);
        }
      }
    });
  }

  getPopularMovieList({bool isPagination = false}) {
    checkConnectivity().then((connectivity) {
      if (isPagination) {
        isApiPagination.value = true;
      } else {
        isApiCall.value = true;
      }
      ApiService.callGetApi("${ApiService.popular}${nextPaginationPopularValue.value}", () {
        if (isPagination) {
          isApiPagination.value = false;
        } else {
          isApiCall.value = false;
        }
      }).then((response) {
        if (isPagination) {
          isApiPagination.value = false;
        } else {
          isApiCall.value = false;
        }
        if (response != null) {
          MovieListModelClass responseModel =
          MovieListModelClass.fromJson(response);
          if (responseModel != null) {
            if (isPagination) {
              popularList.addAll(responseModel.results ?? []);
            } else {
              popularList.value = responseModel.results ?? [];
            }
            print("popularList ===> $popularList");
            nextPaginationPopularValue.value = (responseModel.page! + 1).toString();
          }
        }
      });
    });
  }

}