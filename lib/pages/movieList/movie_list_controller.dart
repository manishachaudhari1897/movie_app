import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/apiservice/api_service.dart';
import 'package:movie_app/constant/componants.dart';
import 'package:movie_app/model/movie_list_model_class.dart';

class MovieListController extends GetxController with GetSingleTickerProviderStateMixin {
  final isApiCall = false.obs;
  final isApiPagination = false.obs;
  final nextPaginationPopularValue = "".obs;
  final nextPaginationTopRatedValue = "".obs;
  final nextPaginationUpComingValue = "".obs;
  final popularList = <Results>[].obs;
  final topRatedList = <Results>[].obs;
  final upComingList = <Results>[].obs;
  final popularListOnSearch = <Results>[].obs;
  final topRatedListOnSearch = <Results>[].obs;
  final upComingListOnSearch = <Results>[].obs;
  final listScrollController = ScrollController().obs;

  final searchEditController = TextEditingController().obs;
  late TabController tabController;
  final showType = "grid".obs;
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Popular'),
    const Tab(text: 'Top Rated'),
    const Tab(text: 'Upcoming'),
  ];
  final currentTabIndex = 0.obs;
  final isSearchEnter = false.obs;
  Timer? debounce;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: myTabs.length,initialIndex: 0,)
      ..addListener(() {
        isSearchEnter.value = false;
        searchEditController.value.text = "";
        currentTabIndex.value = tabController.index;
      });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getPopularMovieList();
    getTopRatedMovieList();
    getUpComingMovieList();

    listScrollController.value.addListener(() {
      if (listScrollController.value.position.maxScrollExtent ==
          listScrollController.value.position.pixels) {

        if(currentTabIndex.value == 0) {
          if (nextPaginationPopularValue.value.isNotEmpty) {
            print("object=> Scroller Controller reached");
            getPopularMovieList(isPagination: true);
          }
        }

        if(currentTabIndex.value == 1) {
          if (nextPaginationTopRatedValue.value.isNotEmpty) {
            print("object=> Scroller Controller reached");
            getTopRatedMovieList(isPagination: true);
          }
        }

        if(currentTabIndex.value == 2) {
          if (nextPaginationUpComingValue.value.isNotEmpty) {
            print("object=> Scroller Controller reached");
            getUpComingMovieList(isPagination: true);
          }
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
            print("nextPaginationPopularValue ===> ${nextPaginationPopularValue.value}");
          }
        }
      });
    });
  }

  getTopRatedMovieList({bool isPagination = false}) {
    checkConnectivity().then((connectivity) {
      if (isPagination) {
        isApiPagination.value = true;
      } else {
        isApiCall.value = true;
      }
      ApiService.callGetApi("${ApiService.topRated}${nextPaginationTopRatedValue.value}", () {
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
              topRatedList.addAll(responseModel.results ?? []);
            } else {
              topRatedList.value = responseModel.results ?? [];
            }
            print("popularList ===> $topRatedList");
            nextPaginationTopRatedValue.value = (responseModel.page! + 1).toString();
            print("nextPaginationPopularValue ===> ${nextPaginationTopRatedValue.value}");
          }
        }
      });
    });
  }

  getUpComingMovieList({bool isPagination = false}) {
    checkConnectivity().then((connectivity) {
      if (isPagination) {
        isApiPagination.value = true;
      } else {
        isApiCall.value = true;
      }
      ApiService.callGetApi("${ApiService.upComing}${nextPaginationUpComingValue.value}", () {
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
              upComingList.addAll(responseModel.results ?? []);
            } else {
              upComingList.value = responseModel.results ?? [];
            }
            print("popularList ===> $upComingList");
            nextPaginationUpComingValue.value = (responseModel.page! + 1).toString();
            print("nextPaginationPopularValue ===> ${nextPaginationUpComingValue.value}");
          }
        }
      });
    });
  }

  getSearchResult(String searchQuery) {
    popularListOnSearch.clear();
    topRatedListOnSearch.clear();
    upComingListOnSearch.clear();
    checkConnectivity().then((connectivity) async {
      if (connectivity) {
        if(popularList.value!=null) {
          for (var i = 0; i < popularList.length; i++) {
            if (popularList[i].title.toString().toLowerCase().contains(searchQuery.toLowerCase())) {
              popularListOnSearch.add(popularList[i]);
            }
          }
        }

        if(topRatedList.value!=null) {
          for (var i = 0; i < topRatedList.length; i++) {
            if (topRatedList[i].title.toString().toLowerCase().contains(searchQuery.toLowerCase())) {
              topRatedListOnSearch.add(topRatedList[i]);
            }
          }
        }

        if(upComingList.value!=null) {
          for (var i = 0; i < upComingList.length; i++) {
            if (upComingList[i].title.toString().toLowerCase().contains(searchQuery.toLowerCase())) {
              upComingListOnSearch.add(upComingList[i]);
            }
          }
        }

        if(popularListOnSearch.isEmpty){
          popularListOnSearch.clear();
        }
        if(topRatedListOnSearch.isEmpty){
          topRatedListOnSearch.clear();
        }
        if(upComingListOnSearch.isEmpty){
          upComingListOnSearch.clear();
        }
      }
    });
  }

}