// import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// import 'package:news_api_flutter_package/model/article.dart';

// class FavoriteProvider extends ChangeNotifier {
//   List<Article> _articles = [];
//   List<Article> get articles => _articles;

//   void toggleFavorite(Article article) {
//     final isExist = _articles.contains(article);
//     if (isExist) {
//       _articles.remove(article);
//     } else {
//       _articles.add(article);
//     }
//     notifyListeners();
//   }

//   bool isExist(Article article) {
//     final isExist = _articles.contains(article);
//     return isExist;
//   }

//   void clearFavorite() {
//     _articles = [];
//     notifyListeners();
//   }

//   static FavoriteProvider of(
//     BuildContext context, {
//     bool listen = true,
//   }) {
//     return Provider.of<FavoriteProvider>(
//       context,
//       listen: listen,
//     );
//   }
// }
