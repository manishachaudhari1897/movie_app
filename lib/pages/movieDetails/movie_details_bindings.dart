import 'package:get/get.dart';
import 'package:movie_app/pages/movieDetails/movie_details_controller.dart';

class MovieDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieDetailsController());
  }

}