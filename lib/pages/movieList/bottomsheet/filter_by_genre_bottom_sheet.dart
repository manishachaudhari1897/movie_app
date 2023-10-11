import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/constant/app_colors.dart';
import 'package:movie_app/constant/app_text.dart';
import 'package:movie_app/pages/movieList/movie_list_controller.dart';

class FilterByGenreBtmSheet extends GetView {
  MovieListController movieListController;

  FilterByGenreBtmSheet({super.key, required this.movieListController});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: colorWhite),
      padding: const EdgeInsets.symmetric(
          vertical: 15.0, horizontal: 24.0),
      child: Obx(() => SingleChildScrollView(
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Filter By Genre",
                        style: AppText.textBold.copyWith(fontSize: 16.0,color: primaryColor),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Icon(
                        Icons.close,
                        size: 20.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1.0,
                  decoration: BoxDecoration(
                      color: colorGreyLight3,
                      borderRadius: BorderRadius.circular(50.0)),
                ).marginOnly(top: 15.0),
                ListView.builder(
                    itemCount: movieListController.genreList.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          movieListController.popularListOnSearch.clear();
                          movieListController.topRatedListOnSearch.clear();
                          movieListController.upComingListOnSearch.clear();
                          movieListController.getGenreFilteredList(index);
                          Get.back();
                          movieListController.isSearchEnter.value = true;
                        },
                        child: Text(
                          movieListController.genreList[index].name ?? "",
                          style: AppText.textRegular
                              .copyWith(color: primaryColor, fontSize: 14.0),
                          softWrap: true,
                        ).marginOnly(top: 15.0),
                      );
                })
              ],
            ),
      )),
    );
  }
}
