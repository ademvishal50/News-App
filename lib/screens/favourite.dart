import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_app/models/favourite_model.dart';
import 'bottom_navigation.dart';
import 'package:intl/intl.dart';
import 'fullnews.dart';

// ignore: must_be_immutable
class FavoritesPage extends StatefulWidget {
  late List<ListArticle> articleList;
  FavoritesPage({super.key, required this.articleList});
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  late List<ListArticle> articleList; // Declaring articleList as a class member

  @override
  void initState() {
    super.initState();
    // Initialize articleList in the initState method
    articleList = widget.articleList;
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    articleList = arguments['articleList'] as List<ListArticle>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Favourites",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [Expanded(child: _buildNewsListView(articleList))],
      )),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/top_stories',
                arguments: {'articleList': articleList});
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/categories',
                arguments: {'articleList': articleList});
          }
        },
      ),
    );
  }

  Widget _buildNewsListView(List<ListArticle> articleList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Article? article = articleList[index].article;
        bool? isLiked = articleList[index].isLiked;

        return _buildNewsItem(article!, isLiked!, index);
      },
      itemCount: articleList.length,
    );
  }

  Widget _buildNewsItem(Article article, bool isLiked, int index) {
    DateTime dateTime = DateTime.parse(article.publishedAt!);
    String formattedDate = DateFormat("MMMM d, y 'at' h:mm a").format(dateTime);
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullNewsPage(url: article.url!),
            ));
      },
      title: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Image.network(
                  article.urlToImage ?? "",
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported);
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title!,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "${article.source.name!} $formattedDate",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              )),
              IconButton(
                icon: isLiked
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                color: Colors.blue,
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                    articleList[index].isLiked = isLiked;
                    articleList.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
