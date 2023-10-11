import 'package:get/get.dart';
import 'package:movie_app/pages/movieList/movie_list_controller.dart';

class MovieListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieListController());
  }

}