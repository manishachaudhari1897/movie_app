import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:movie_app/apiservice/api_service.dart';
import 'package:movie_app/constant/app_colors.dart';
import 'package:movie_app/constant/app_fonst.dart';
import 'package:movie_app/constant/app_images.dart';
import 'package:movie_app/constant/app_text.dart';
import 'package:movie_app/constant/componants.dart';
import 'package:movie_app/model/genre_model_class.dart';
import 'package:movie_app/model/movie_list_model_class.dart';
import 'package:movie_app/pages/movieList/bottomsheet/filter_by_genre_bottom_sheet.dart';
import 'package:movie_app/pages/movieList/movie_list_controller.dart';

class MovieListView extends GetView<MovieListController> {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: colorGreyLight4,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: colorGreyLight3,
            automaticallyImplyLeading: false,
            title: getHeaderView(context),
            bottom: TabBar(
              controller: controller.tabController,
              isScrollable: false,
              indicatorPadding: const EdgeInsets.only(left: 15.0, right: 15.0),
              indicatorWeight: 1,
              indicatorColor: colorDarkRed,
              labelColor: primaryColor,
              labelStyle: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: appFont,
                  fontWeight: FontWeight.bold),
              unselectedLabelColor: primaryColor,
              unselectedLabelStyle: const TextStyle(
                  fontSize: 14.0,
                  fontFamily: appFont,
                  fontWeight: FontWeight.normal),
              tabs: controller.myTabs,
            ),
          ),
          body: Container(
              decoration: const BoxDecoration(color: colorWhite),
              child: Obx(() => TabBarView(
                    controller: controller.tabController,
                    children: [
                      controller.isSearchEnter.value
                          ? controller.popularListOnSearch.isNotEmpty
                              ? controller.showType.value == "grid"
                                  ? getSearchMoviesGridView(
                                      context, controller.popularListOnSearch)
                                  : getSearchMoviesListView(
                                      context, controller.popularListOnSearch)
                              : const Center(child: Text("No Movies"))
                          : controller.showType.value == "grid"
                              ? getPopularMoviesGridView(context)
                              : getPopularMoviesListView(context),
                      controller.isSearchEnter.value
                          ? controller.topRatedListOnSearch.isNotEmpty
                              ? controller.showType.value == "grid"
                                  ? getSearchMoviesGridView(
                                      context, controller.topRatedListOnSearch)
                                  : getSearchMoviesListView(
                                      context, controller.topRatedListOnSearch)
                              : const Center(child: Text("No Movies"))
                          : controller.showType.value == "grid"
                              ? getTopRatedMoviesGridView(context)
                              : getTopRatedMoviesListView(context),
                      controller.isSearchEnter.value
                          ? controller.upComingListOnSearch.isNotEmpty
                              ? controller.showType.value == "grid"
                                  ? getSearchMoviesGridView(
                                      context, controller.upComingListOnSearch)
                                  : getSearchMoviesListView(
                                      context, controller.upComingListOnSearch)
                              : const Center(child: Text("No Movies"))
                          : controller.showType.value == "grid"
                              ? getUpComingMoviesGridView(context)
                              : getUpComingMoviesListView(context)
                    ],
                  )))),
    );
  }

  Widget getHeaderView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Obx(() => Container(
                height: 45,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 15.0),
                decoration: BoxDecoration(
                  color:
                      colorWhite /*(isEditable ?? true) ? colorWhite : colorGreyLight3*/,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: colorGreyLight3, width: 1.0),
                ),
                child: TextFormField(
                  controller: controller.searchEditController.value,
                  keyboardType: TextInputType.text,
                  enabled: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    counterText: "",
                    counter: null,
                    hintText: "Search by movie name",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: primaryColor.withOpacity(0.6),
                    ).marginOnly(bottom: 20.0),
                    contentPadding: EdgeInsets.zero,
                    hintStyle: AppText.textRegular.copyWith(
                      fontSize: 14.0,
                      color: primaryColor.withOpacity(0.6),
                    ),
                  ),
                  style: AppText.textRegular
                      .copyWith(fontSize: 14.0, color: primaryColor),
                  enableInteractiveSelection: true,
                  textInputAction: TextInputAction.next,
                  maxLength: 35,
                  onChanged: (value) {
                    controller.popularListOnSearch.clear();
                    controller.topRatedListOnSearch.clear();
                    controller.upComingListOnSearch.clear();
                    controller.isSearchEnter.value = !checkString(
                        controller.searchEditController.value.text.trim());
                    if (controller.searchEditController.value.text
                            .trim()
                            .length >
                        1) {
                      if (controller.debounce?.isActive ?? false)
                        controller.debounce?.cancel();
                      controller.debounce =
                          Timer(const Duration(milliseconds: 500), () {
                        controller.getSearchResult(
                            controller.searchEditController.value.text);
                      });
                    }
                  },
                  onFieldSubmitted: (value) {},
                ),
              )),
        ),
        Obx(() => GestureDetector(
              onTap: () {
                if (controller.showType.value == "grid") {
                  controller.showType.value = "";
                } else {
                  controller.showType.value = "grid";
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 45.0,
                width: 45.0,
                decoration: BoxDecoration(
                    border: Border.all(color: colorGreyLight3, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                    color: colorWhite),
                child: Center(
                  child: SvgPicture.asset(
                    controller.showType.value == "grid" ? icGrid : icList,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ).marginOnly(left: 8.0, top: 15.0)),
        GestureDetector(
              onTap: () {
                controller.isSearchEnter.value = false;
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints.loose(Size(double.infinity, MediaQuery.of(context).size.height * 0.7)),
                    builder: (context) => FilterByGenreBtmSheet(movieListController: controller,));

              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 45.0,
                width: 45.0,
                decoration: BoxDecoration(
                    border: Border.all(color: colorGreyLight3, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                    color: colorWhite),
                child: Center(
                  child: SvgPicture.asset(
                    icFilter,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ).marginOnly(left: 8.0, top: 15.0)

      ],
    );
  }

  getPopularMoviesGridView(BuildContext context) {
    return Obx(() => controller.popularList.isEmpty
        ? const Offstage()
        : GridView.builder(
            controller: controller.listScrollController.value,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1 / 1.8),
            itemCount: controller.popularList.length,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            itemBuilder: (chatContext, index) {
              return Container(
                decoration: BoxDecoration(
                  color: colorGreyLight4,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: colorGreyLight3, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 25.0,
                      spreadRadius: 2.0,
                      offset: const Offset(
                        0,
                        2,
                      ), //New
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                      child: SizedBox(
                        height: 200,
                        child: Container(
                          decoration: const BoxDecoration(color: colorWhite),
                          child: controller.popularList[index].posterPath
                                  .toString()
                                  .isEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 2,
                                  child: Icon(Icons.person))
                              : SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 2,
                                  child: getNetworkImageView(
                                    ApiService.imageBaseURL +
                                        controller.popularList[index].posterPath
                                            .toString(),
                                    height: 100,
                                    width: 200,
                                    boxFit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.popularList[index].title ?? "",
                            style: AppText.textBold
                                .copyWith(color: primaryColor, fontSize: 16.0),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            controller.popularList[index].releaseDate ?? "",
                            style: AppText.textRegular.copyWith(
                                color: primaryColor,
                                fontSize: 14.0,
                                overflow: TextOverflow.ellipsis),
                            softWrap: true,
                            maxLines: 1,
                          ),
                          Text(
                            "Popularity: ${controller.popularList[index].popularity ?? ""}",
                            style: AppText.textRegular.copyWith(
                                color: colorGreyLight, fontSize: 12.0),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            "Original Language : ${controller.popularList[index].originalLanguage ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 12.0),
                            softWrap: true,
                          ),
                          Text(
                            "Average Vote : ${controller.popularList[index].voteAverage ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 12.0),
                            softWrap: true,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ));
  }

  getPopularMoviesListView(BuildContext context) {
    return Obx(() => controller.popularList.isEmpty
        ? const Offstage()
        : ListView.builder(
            controller: controller.listScrollController.value,
            itemCount: controller.popularList.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        child: SizedBox(
                          height: 200,
                          child: Container(
                            decoration: const BoxDecoration(color: colorWhite),
                            child: controller.popularList[index].posterPath
                                    .toString()
                                    .isEmpty
                                ? SizedBox(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * 2,
                                    child: const Icon(Icons.person))
                                : SizedBox(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * 2,
                                    child: getNetworkImageView(
                                      ApiService.imageBaseURL +
                                          controller
                                              .popularList[index].posterPath
                                              .toString(),
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.popularList[index].title ?? "",
                          style: AppText.textBold
                              .copyWith(color: primaryColor, fontSize: 16.0),
                          softWrap: true,
                        ).marginOnly(top: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                controller.popularList[index].releaseDate ?? "",
                                style: AppText.textRegular.copyWith(
                                    color: primaryColor, fontSize: 14.0),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "Popularity: ${controller.popularList[index].popularity ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 12.0),
                              softWrap: true,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Original Language : ${controller.popularList[index].originalLanguage ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: colorGreyLight, fontSize: 12.0),
                              softWrap: true,
                            ),
                            Text(
                              "Average Vote : ${controller.popularList[index].voteAverage ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 12.0),
                              softWrap: true,
                            ),
                          ],
                        ).marginOnly(top: 5.0),
                      ],
                    ).marginOnly(left: 10.0, right: 10.0, bottom: 15.0)
                  ],
                ),
              );
            }));
  }

  getTopRatedMoviesGridView(BuildContext context) {
    return Obx(() => controller.topRatedList.isEmpty
        ? const Offstage()
        : GridView.builder(
            controller: controller.listScrollController.value,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1 / 1.8),
            itemCount: controller.topRatedList.length,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            itemBuilder: (chatContext, index) {
              return Container(
                decoration: BoxDecoration(
                  color: colorGreyLight4,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: colorGreyLight3, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 25.0,
                      spreadRadius: 2.0,
                      offset: const Offset(
                        0,
                        2,
                      ), //New
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                      child: SizedBox(
                        height: 200,
                        child: Container(
                          decoration: const BoxDecoration(color: colorWhite),
                          child: controller.topRatedList[index].posterPath
                                  .toString()
                                  .isEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 2,
                                  child: const Icon(Icons.person))
                              : SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 2,
                                  child: getNetworkImageView(
                                    ApiService.imageBaseURL +
                                        controller
                                            .topRatedList[index].posterPath
                                            .toString(),
                                    height: 100,
                                    width: 200,
                                    boxFit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.topRatedList[index].title ?? "",
                            style: AppText.textBold
                                .copyWith(color: primaryColor, fontSize: 16.0),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            controller.topRatedList[index].releaseDate ?? "",
                            style: AppText.textRegular.copyWith(
                                color: primaryColor,
                                fontSize: 14.0,
                                overflow: TextOverflow.ellipsis),
                            softWrap: true,
                            maxLines: 1,
                          ),
                          Text(
                            "Popularity: ${controller.topRatedList[index].popularity ?? ""}",
                            style: AppText.textRegular.copyWith(
                                color: colorGreyLight,
                                fontSize: 12.0,
                                decoration: TextDecoration.lineThrough),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            "Original Language : ${controller.topRatedList[index].originalLanguage ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 12.0),
                            softWrap: true,
                          ),
                          Text(
                            "Average Vote : ${controller.topRatedList[index].voteAverage ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 12.0),
                            softWrap: true,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ));
  }

  getTopRatedMoviesListView(BuildContext context) {
    return Obx(() => controller.topRatedList.isEmpty
        ? const Offstage()
        : ListView.builder(
            controller: controller.listScrollController.value,
            itemCount: controller.topRatedList.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        child: SizedBox(
                          height: 200,
                          child: Container(
                            decoration: const BoxDecoration(color: colorWhite),
                            child: controller.topRatedList[index].posterPath
                                    .toString()
                                    .isEmpty
                                ? SizedBox(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * 2,
                                    child: const Icon(Icons.person))
                                : SizedBox(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * 2,
                                    child: getNetworkImageView(
                                      ApiService.imageBaseURL +
                                          controller
                                              .topRatedList[index].posterPath
                                              .toString(),
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.topRatedList[index].title ?? "",
                          style: AppText.textBold
                              .copyWith(color: primaryColor, fontSize: 16.0),
                          softWrap: true,
                        ).marginOnly(top: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                controller.topRatedList[index].releaseDate ??
                                    "",
                                style: AppText.textRegular.copyWith(
                                    color: primaryColor, fontSize: 14.0),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "Popularity: ${controller.topRatedList[index].popularity ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 12.0),
                              softWrap: true,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Original Language : ${controller.topRatedList[index].originalLanguage ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: colorGreyLight, fontSize: 12.0),
                              softWrap: true,
                            ),
                            Text(
                              "Average Vote : ${controller.topRatedList[index].voteAverage ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 12.0),
                              softWrap: true,
                            ),
                          ],
                        ).marginOnly(top: 5.0),
                      ],
                    ).marginOnly(left: 10.0, right: 10.0, bottom: 15.0)
                  ],
                ),
              );
            }));
  }

  getUpComingMoviesGridView(BuildContext context) {
    return Obx(() => controller.upComingList.isEmpty
        ? const Offstage()
        : GridView.builder(
            controller: controller.listScrollController.value,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1 / 1.8),
            itemCount: controller.upComingList.length,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            itemBuilder: (chatContext, index) {
              return Container(
                decoration: BoxDecoration(
                  color: colorGreyLight4,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: colorGreyLight3, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 25.0,
                      spreadRadius: 2.0,
                      offset: const Offset(
                        0,
                        2,
                      ), //New
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                      child: SizedBox(
                        height: 200,
                        child: Container(
                          decoration: const BoxDecoration(color: colorWhite),
                          child: controller.upComingList[index].posterPath
                                  .toString()
                                  .isEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 2,
                                  child: const Icon(Icons.person))
                              : SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 2,
                                  child: getNetworkImageView(
                                    ApiService.imageBaseURL +
                                        controller
                                            .upComingList[index].posterPath
                                            .toString(),
                                    height: 100,
                                    width: 200,
                                    boxFit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.upComingList[index].title ?? "",
                            style: AppText.textBold
                                .copyWith(color: primaryColor, fontSize: 16.0),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            controller.upComingList[index].releaseDate ?? "",
                            style: AppText.textRegular.copyWith(
                                color: primaryColor,
                                fontSize: 14.0,
                                overflow: TextOverflow.ellipsis),
                            softWrap: true,
                            maxLines: 1,
                          ),
                          Text(
                            "Popularity: ${controller.upComingList[index].popularity ?? ""}",
                            style: AppText.textRegular.copyWith(
                                color: colorGreyLight,
                                fontSize: 12.0,
                                decoration: TextDecoration.lineThrough),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            "Original Language : ${controller.upComingList[index].originalLanguage ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 12.0),
                            softWrap: true,
                          ),
                          Text(
                            "Average Vote : ${controller.upComingList[index].voteAverage ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 12.0),
                            softWrap: true,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ));
  }

  getUpComingMoviesListView(BuildContext context) {
    return Obx(() => controller.upComingList.isEmpty
        ? const Offstage()
        : ListView.builder(
            controller: controller.listScrollController.value,
            itemCount: controller.upComingList.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        child: SizedBox(
                          height: 200,
                          child: Container(
                            decoration: const BoxDecoration(color: colorWhite),
                            child: controller.upComingList[index].posterPath
                                    .toString()
                                    .isEmpty
                                ? SizedBox(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * 2,
                                    child: const Icon(Icons.person))
                                : SizedBox(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * 2,
                                    child: getNetworkImageView(
                                      ApiService.imageBaseURL +
                                          controller
                                              .upComingList[index].posterPath
                                              .toString(),
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.upComingList[index].title ?? "",
                          style: AppText.textBold
                              .copyWith(color: primaryColor, fontSize: 16.0),
                          softWrap: true,
                        ).marginOnly(top: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                controller.upComingList[index].releaseDate ??
                                    "",
                                style: AppText.textRegular.copyWith(
                                    color: primaryColor, fontSize: 14.0),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "Popularity: ${controller.upComingList[index].popularity ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 12.0),
                              softWrap: true,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Original Language : ${controller.upComingList[index].originalLanguage ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: colorGreyLight, fontSize: 12.0),
                              softWrap: true,
                            ),
                            Text(
                              "Average Vote : ${controller.upComingList[index].voteAverage ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 12.0),
                              softWrap: true,
                            ),
                          ],
                        ).marginOnly(top: 5.0),
                      ],
                    ).marginOnly(left: 10.0, right: 10.0, bottom: 15.0)
                  ],
                ),
              );
            }));
  }

  getSearchMoviesGridView(BuildContext context, List<Results> list) {
    return list.isEmpty
        ? const Offstage()
        : GridView.builder(
            controller: controller.listScrollController.value,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1 / 1.8),
            itemCount: list.length,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            itemBuilder: (chatContext, index) {
              return Container(
                decoration: BoxDecoration(
                  color: colorGreyLight4,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: colorGreyLight3, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 25.0,
                      spreadRadius: 2.0,
                      offset: const Offset(
                        0,
                        2,
                      ), //New
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                      child: SizedBox(
                        height: 200,
                        child: Container(
                          decoration: const BoxDecoration(color: colorWhite),
                          child: list[index].posterPath.toString().isEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 2,
                                  child: Icon(Icons.person))
                              : SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 2,
                                  child: getNetworkImageView(
                                    ApiService.imageBaseURL +
                                        list[index].posterPath.toString(),
                                    height: 100,
                                    width: 200,
                                    boxFit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list[index].title ?? "",
                            style: AppText.textBold
                                .copyWith(color: primaryColor, fontSize: 16.0),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            list[index].releaseDate ?? "",
                            style: AppText.textRegular.copyWith(
                                color: primaryColor,
                                fontSize: 14.0,
                                overflow: TextOverflow.ellipsis),
                            softWrap: true,
                            maxLines: 1,
                          ),
                          Text(
                            "Popularity: ${list[index].popularity ?? ""}",
                            style: AppText.textRegular.copyWith(
                                color: colorGreyLight, fontSize: 12.0),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            "Original Language : ${list[index].originalLanguage ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 12.0),
                            softWrap: true,
                          ),
                          Text(
                            "Average Vote : ${list[index].voteAverage ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 12.0),
                            softWrap: true,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }

  getSearchMoviesListView(BuildContext context, List<Results> list) {
    return Obx(() => list.isEmpty
        ? const Offstage()
        : ListView.builder(
            controller: controller.listScrollController.value,
            itemCount: list.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        child: SizedBox(
                          height: 200,
                          child: Container(
                            decoration: const BoxDecoration(color: colorWhite),
                            child: list[index].posterPath.toString().isEmpty
                                ? SizedBox(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * 2,
                                    child: const Icon(Icons.person))
                                : SizedBox(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * 2,
                                    child: getNetworkImageView(
                                      ApiService.imageBaseURL +
                                          list[index].posterPath.toString(),
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[index].title ?? "",
                          style: AppText.textBold
                              .copyWith(color: primaryColor, fontSize: 16.0),
                          softWrap: true,
                        ).marginOnly(top: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                list[index].releaseDate ?? "",
                                style: AppText.textRegular.copyWith(
                                    color: primaryColor, fontSize: 14.0),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "Popularity: ${list[index].popularity ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 12.0),
                              softWrap: true,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Original Language : ${list[index].originalLanguage ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: colorGreyLight, fontSize: 12.0),
                              softWrap: true,
                            ),
                            Text(
                              "Average Vote : ${list[index].voteAverage ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 12.0),
                              softWrap: true,
                            ),
                          ],
                        ).marginOnly(top: 5.0),
                      ],
                    ).marginOnly(left: 10.0, right: 10.0, bottom: 15.0)
                  ],
                ),
              );
            }));
  }
}
