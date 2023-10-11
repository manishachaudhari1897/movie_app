import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:movie_app/apiservice/api_service.dart';
import 'package:movie_app/constant/app_colors.dart';
import 'package:movie_app/constant/app_images.dart';
import 'package:movie_app/constant/app_text.dart';
import 'package:movie_app/constant/componants.dart';
import 'package:movie_app/model/movie_details_model_class.dart';
import 'package:movie_app/pages/movieDetails/movie_details_controller.dart';

class MovieDetailsView extends GetView<MovieDetailsController> {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: colorGreyLight4,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: colorGreyLight3,
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: primaryColor,
                )),
            title: Obx(() => Text(
                  controller.movieDetails.value?.title ?? "",
                  style: AppText.textBold
                      .copyWith(color: primaryColor, fontSize: 18.0),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ))),
        body: SafeArea(
          child: Obx(() => controller.movieDetails != null
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                          child: SizedBox(
                            height: 300,
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: colorWhite),
                              child: (controller
                                              .movieDetails.value?.posterPath ??
                                          "")
                                      .isEmpty
                                  ? SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Image.asset(
                                        placeHolder2,
                                        fit: BoxFit.cover,
                                      ))
                                  : SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              2,
                                      child: getNetworkImageView(
                                        ApiService.imageBaseURL +
                                            controller
                                                .movieDetails.value!.posterPath
                                                .toString()
                                                .toString(),
                                        boxFit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        controller.movieDetails.value?.title ?? "",
                        style: AppText.textBold
                            .copyWith(color: primaryColor, fontSize: 18.0),
                        softWrap: true,
                      ).marginOnly(top: 15.0, left: 15.0, right: 15.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Popularity : ${controller.movieDetails.value?.popularity ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 14.0),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "Release Date : ${controller.movieDetails.value?.releaseDate ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 14.0),
                            softWrap: true,
                          ),
                        ],
                      ).marginOnly(top: 15.0, left: 15.0, right: 15.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Vote Average : ${controller.movieDetails.value?.voteAverage ?? ""}",
                              style: AppText.textRegular.copyWith(
                                  color: primaryColor, fontSize: 14.0),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "Vote Count : ${controller.movieDetails.value?.voteCount ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 14.0),
                            softWrap: true,
                          ),
                        ],
                      ).marginOnly(top: 15.0, left: 15.0, right: 15.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            "Budget : ${controller.movieDetails.value?.budget ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 14.0),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          )),
                          Text(
                            "Revenue : ${controller.movieDetails.value?.revenue ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 14.0),
                            softWrap: true,
                          ),
                        ],
                      ).marginOnly(top: 15.0, left: 15.0, right: 15.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            "Status : ${controller.movieDetails.value?.status ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 14.0),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          )),
                          Text(
                            "Runtime : ${controller.movieDetails.value?.runtime ?? ""}",
                            style: AppText.textRegular
                                .copyWith(color: primaryColor, fontSize: 14.0),
                            softWrap: true,
                          ),
                        ],
                      ).marginOnly(top: 15.0, left: 15.0, right: 15.0),
                      Text(
                        "Movie Description",
                        style: AppText.textBold
                            .copyWith(fontSize: 14.0, color: primaryColor),
                      ).marginOnly(top: 15.0, left: 15.0, right: 15.0),
                      Text(
                        controller.movieDetails.value?.overview ?? "",
                        maxLines: 5,
                        textAlign: TextAlign.start,
                        style: AppText.textRegular
                            .copyWith(fontSize: 12.0, color: colorGreyLight),
                      ).marginOnly(top: 10.0, left: 15.0, right: 15.0),
                      GestureDetector(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                                top: 20.0, left: 15.0, right: 15.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: primaryColor, width: 1.0),
                                borderRadius: BorderRadius.circular(5.0),
                                color: primaryColor),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    icCartOutline,
                                    color: colorGreyLight3,
                                  ),
                                  Text(
                                    "Book Your Tickets",
                                    style: AppText.textBold.copyWith(
                                        color: colorGreyLight3, fontSize: 14.0),
                                  ).marginOnly(left: 8.0),
                                ],
                              ),
                            )),
                        onTap: () {},
                      ),
                      Obx(() => Visibility(
                            visible:
                                (controller.movieDetails.value?.genres ?? [])
                                        .isNotEmpty
                                    ? true
                                    : false,
                            child: widgetWithTitleAndData(
                              "Genres",
                              //  getFabricGridWidget(context),
                              chipListViewGenres(
                                  (controller.movieDetails.value?.genres ??
                                      [])),
                            ).marginOnly(top: 25.0, left: 15.0, right: 15.0),
                          )),
                      Obx(() => Visibility(
                            visible:
                                (controller.movieDetails.value?.genres ?? [])
                                        .isNotEmpty
                                    ? true
                                    : false,
                            child: widgetWithTitleAndData(
                              "Production Companies",
                              //  getFabricGridWidget(context),
                              chipListViewCompanies((controller.movieDetails
                                      .value?.productionCompanies ??
                                  [])),
                            ).marginOnly(top: 25.0, left: 15.0, right: 15.0),
                          )),
                      Obx(() => Visibility(
                            visible:
                                (controller.movieDetails.value?.genres ?? [])
                                        .isNotEmpty
                                    ? true
                                    : false,
                            child: widgetWithTitleAndData(
                              "Production Countries",
                              //  getFabricGridWidget(context),
                              chipListViewCountries((controller.movieDetails
                                      .value?.productionCountries ??
                                  [])),
                            ).marginOnly(top: 25.0, left: 15.0, right: 15.0),
                          )),
                      Obx(() => Visibility(
                            visible:
                                (controller.movieDetails.value?.genres ?? [])
                                        .isNotEmpty
                                    ? true
                                    : false,
                            child: widgetWithTitleAndData(
                              "Spoken Languages",
                              //  getFabricGridWidget(context),
                              chipListViewLanguages((controller
                                      .movieDetails.value?.spokenLanguages ??
                                  [])),
                            ).marginOnly(top: 25.0, left: 15.0, right: 15.0),
                          )),
                    ],
                  ).marginOnly(bottom: 20.0),
                )
              : const Offstage()),
        ),
      ),
    );
  }

  Widget widgetWithTitleAndData(String title, Widget dataWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppText.textBold.copyWith(fontSize: 14.0, color: primaryColor),
        ),
        dataWidget.marginOnly(top: 10.0)
      ],
    );
  }

  chipListViewGenres(List<Genres> list) {
    List<Widget> categoryChip = [];
    for (int i = 0; i < list.length; i++) {
      categoryChip.add(Chip(
        label: Text(
          list[i].name ?? "",
          style: AppText.textRegular
              .copyWith(fontSize: 12.0, color: colorGreyLight3),
        ),
        backgroundColor: colorDarkRed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.all(7.0),
        labelPadding: EdgeInsets.zero,
        labelStyle: AppText.textMedium.copyWith(fontSize: 12.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ));
    }
    return Wrap(spacing: 10.0, runSpacing: 10.0, children: categoryChip);
  }

  chipListViewCompanies(List<ProductionCompanies> list) {
    List<Widget> categoryChip = [];
    for (int i = 0; i < list.length; i++) {
      categoryChip.add(Chip(
        label: Text(
          list[i].name ?? "",
          style: AppText.textRegular
              .copyWith(fontSize: 12.0, color: colorGreyLight3),
        ),
        backgroundColor: colorDarkRed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.all(7.0),
        labelPadding: EdgeInsets.zero,
        labelStyle: AppText.textMedium.copyWith(fontSize: 12.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ));
    }
    return Wrap(spacing: 10.0, runSpacing: 10.0, children: categoryChip);
  }

  chipListViewCountries(List<ProductionCountries> list) {
    List<Widget> categoryChip = [];
    for (int i = 0; i < list.length; i++) {
      categoryChip.add(Chip(
        label: Text(
          list[i].name ?? "",
          style: AppText.textRegular
              .copyWith(fontSize: 12.0, color: colorGreyLight3),
        ),
        backgroundColor: colorDarkRed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.all(7.0),
        labelPadding: EdgeInsets.zero,
        labelStyle: AppText.textMedium.copyWith(fontSize: 12.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ));
    }
    return Wrap(spacing: 10.0, runSpacing: 10.0, children: categoryChip);
  }

  chipListViewLanguages(List<SpokenLanguages> list) {
    List<Widget> categoryChip = [];
    for (int i = 0; i < list.length; i++) {
      categoryChip.add(Chip(
        label: Text(
          list[i].name ?? "",
          style: AppText.textRegular
              .copyWith(fontSize: 12.0, color: colorGreyLight3),
        ),
        backgroundColor: colorDarkRed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.all(7.0),
        labelPadding: EdgeInsets.zero,
        labelStyle: AppText.textMedium.copyWith(fontSize: 12.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ));
    }
    return Wrap(spacing: 10.0, runSpacing: 10.0, children: categoryChip);
  }
}
