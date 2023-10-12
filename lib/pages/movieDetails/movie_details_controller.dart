import 'package:get/get.dart';
import 'package:movie_app/apiservice/api_service.dart';
import 'package:movie_app/constant/componants.dart';
import 'package:movie_app/model/movie_details_model_class.dart';

class MovieDetailsController extends GetxController {
  final isApiCall = false.obs;
  final movieDetails = Rx<MovieDetailsModelClass?>(null);
  final movieId = "".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      movieId.value = Get.arguments["movieId"] ?? "";
    }
    getPopularMovieList();
  }

  getPopularMovieList() {
    checkConnectivity().then((connectivity) {
      if(connectivity == true) {
        isApiCall.value = true;
        ApiService.callGetApi("${ApiService.movieDetails}${movieId.value}", () {
          isApiCall.value = false;
        }).then((response) {
          isApiCall.value = false;
          if (response != null) {
            MovieDetailsModelClass responseModel =
            MovieDetailsModelClass.fromJson(response);
            if (responseModel != null) {
              movieDetails.value = responseModel;
            }
          }
        });
      } else {
        isApiCall.value = false;
      }
    });
  }
}
