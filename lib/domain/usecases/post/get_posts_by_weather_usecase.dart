import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class GetPostsByWeatherUseCase {
  final PostRepository _repository;

  GetPostsByWeatherUseCase(this._repository);

  Future<List<Post>> execute(String weather) {
    return _repository.getPostsByWeather(weather);
  }
}
