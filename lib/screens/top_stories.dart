import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_app/models/favourite_model.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'package:intl/intl.dart';
import 'fullnews.dart';

// ignore: must_be_immutable
class TopStoriesPage extends StatefulWidget {
  late List<ListArticle> likedList;
  TopStoriesPage({super.key, required this.likedList});

  @override
  // ignore: library_private_types_in_public_api
  _TopStoriesPageState createState() => _TopStoriesPageState();
}

class _TopStoriesPageState extends State<TopStoriesPage> {
  bool isFavorite = false;
  late Future<List<Article>> future;
  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  List<ListArticle> articleList = [];
  List<ListArticle> likedList = [];
  List<Article> topStories = [];
  @override
  void initState() {
    future = getNewsData();
    super.initState();
  }

  Future<List<Article>> getNewsData() async {
    NewsAPI newsAPI = NewsAPI('Your Api Key');
    return await newsAPI.getTopHeadlines(
      country: "in",
      query: searchTerm,
      pageSize: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    likedList = arguments['articleList'] as List<ListArticle>;
    return Scaffold(
      appBar: isSearching ? searchAppBar() : appBar(),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading the news"),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    if (articleList.isNotEmpty) {
                      return _buildNewsListView(articleList);
                    } else {
                      articleList =
                          removeNullImage(snapshot.data as List<Article>);
                      return _buildNewsListView(articleList);
                    }
                  } else {
                    return const Center(
                      child: Text("No news available"),
                    );
                  }
                }
              },
              future: future,
            ),
          )
        ],
      )),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushReplacementNamed(context, '/favorites',
                arguments: {'articleList': likedList});
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/categories',
                arguments: {'articleList': likedList});
          }
        },
      ),
    );
  }

  List<ListArticle> removeNullImage(List<Article> articles) {
    List<ListArticle> newArticles = [];
    bool? liked = false;
    if (articleList.isNotEmpty) {
      for (int i = 0; i < articleList.length; i++) {
        liked = articleList[i].isLiked;
        if (liked!) {
          newArticles.add(ListArticle(articles[i], liked));
          continue;
        } else {
          newArticles.add(ListArticle(articles[i], false));
        }
      }
    } else {
      for (int i = 0; i < articles.length; i++) {
        if (articles[i].urlToImage != null) {
          newArticles.add(ListArticle(articles[i], false));
        }
      }
    }
    return newArticles;
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
                    likedList.add(ListArticle(article, isLiked));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  searchAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            isSearching = false;
            searchTerm = null;
            searchController.text = "";
            articleList = [];
            future = getNewsData();
          });
        },
      ),
      title: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                articleList = [];
                searchTerm = searchController.text;
                future = getNewsData();
              });
            },
            icon: const Icon(Icons.search)),
      ],
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text(
        "News Now",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearching = true;
              });
            },
            icon: const Icon(Icons.search)),
      ],
    );
  }
}
