import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:movie_app/apiservice/api_service.dart';
import 'package:movie_app/constant/app_colors.dart';
import 'package:movie_app/constant/app_fonst.dart';
import 'package:movie_app/constant/app_images.dart';
import 'package:movie_app/constant/app_text.dart';
import 'package:movie_app/constant/componants.dart';
import 'package:movie_app/pages/movieList/movie_list_controller.dart';

class MovieListView extends GetView<MovieListController> {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    print("${controller.isApiCall.value}");
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
              tabs: const [
                Tab(
                  child: Text(
                    "Popular",
                  ),
                ),
                Tab(
                  child: Text("Top Rated"),
                ),
                Tab(
                  child: Text("Upcoming"),
                ),
              ],
            ),
          ),
          body: Container(
              decoration: BoxDecoration(color: colorWhite),
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  /*controller.isSearchEnter.value
                    ? controller.followersListOnSearch.isNotEmpty
                    ? getFollowerListFromSearch()
                    : const Center(child: Text("No Movies"))
                    : controller.followersCount.value != "0"
                    ? */
                  getPopularMoviesList(context),
                  // : const Center(child: Text("No Movies")),
                  // controller.followersCount.value != "0"
                  //     ? getFollowerList()
                  //     : const Center(child: Text(noSearchFound)),
                  /*controller.isSearchEnter.value
                    ? controller.followingListOnSearch.isNotEmpty
                    ? getFollowingListFromSearch()
                    : const Center(child: Text("No Movies"))
                    : controller.followingCount.value != "0"
                    ?*/
                  getPopularMoviesList(context),
                  // : const Center(child: Text("No Movies")),
                  getPopularMoviesList(context)
                  // controller.followingCount.value != "0"
                  //     ? getFollowingList()
                  //     : const Center(child: Text(noSearchFound)),
                ],
              ))),
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
                  onChanged: (value) {},
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
            ).marginOnly(left: 10.0, top: 15.0)),
      ],
    );
  }

  getPopularMoviesList(BuildContext context) {
    return Obx(() => controller.popularList.isEmpty
        ? const Offstage()
        : GridView.builder(
      controller:
      controller.listScrollController.value,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 1 / 1.8),
      itemCount: controller.popularList.length,
      padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0),
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
                            "${controller.popularList[index].popularity ?? ""}",
                            style: AppText.textRegular.copyWith(
                                color: colorGreyLight,
                                fontSize: 12.0,
                                decoration: TextDecoration.lineThrough),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            controller.popularList[index].originalLanguage ??
                                "",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 12.0),
                            softWrap: true,
                          ),
                          Text(
                            "vote_average : ${controller.popularList[index].voteAverage ?? ""}",
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
}
