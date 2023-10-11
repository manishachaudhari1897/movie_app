
import 'package:get/get.dart';
import 'package:movie_app/pages/movieDetails/movie_details_bindings.dart';
import 'package:movie_app/pages/movieDetails/movie_details_view.dart';
import 'package:movie_app/pages/movieList/movie_list_bindings.dart';
import 'package:movie_app/pages/movieList/movie_list_view.dart';
import 'package:movie_app/routes/app_routes.dart';

class AppPages {

  static final routes = [
    GetPage(
      name: Paths.movieList,
      page: () => const MovieListView(),
      binding: MovieListBindings(),
      transitionDuration: Duration.zero,
    ),
    GetPage(
      name: Paths.movieDetails,
      page: () => const MovieDetailsView(),
      binding: MovieDetailsBindings(),
      transitionDuration: Duration.zero,
    ),
  ];
}
