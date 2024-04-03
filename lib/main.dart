import 'package:flutter/material.dart';
import 'package:news_app/models/favourite_model.dart';
import 'package:news_app/screens/get_category.dart';
import 'package:news_app/screens/landing.dart';

import "package:flutter_dotenv/flutter_dotenv.dart";
import 'screens/favourite.dart';
import 'screens/top_stories.dart';
import 'screens/categories.dart';

void main() {
  dotenv.load(fileName: ".env");
  List<ListArticle> articleList = [];
  List<ListArticle> likedList = [];
  String? category;

  runApp(MaterialApp(
    title: 'News App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const MyHomePage(),
      '/landing': (context) => const LandingPage(),
      '/favorites': (context) => FavoritesPage(articleList: articleList),
      '/get_category': (context) => GetCategories(
            category: category,
            likedList: likedList,
          ),
      '/top_stories': (context) => TopStoriesPage(likedList: likedList),
      '/categories': (context) => CategoriesPage(
            articleList: articleList,
          ),
    },
    debugShowCheckedModeBanner: false,
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _selectedIndex = 0;

  // final List<Widget> _pages = [
  //   TopStoriesPage(likedList: const []),
  //   CategoriesPage(
  //     articleList: const [],
  //   ),
  //   FavoritesPage(
  //     articleList: const [],
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LandingPage(),
    );
  }
}
