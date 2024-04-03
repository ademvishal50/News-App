import 'package:news_api_flutter_package/model/article.dart';

class ListArticle {
  Article? article;
  bool? isLiked;
  bool? isAdded;

  ListArticle(this.article, this.isLiked);
}
