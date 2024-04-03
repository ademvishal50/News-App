import 'package:flutter/material.dart';
import 'package:news_app/models/category_model.dart';
import 'bottom_navigation.dart';

// import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_app/services/data.dart';
import 'package:news_app/models/favourite_model.dart';

// ignore: must_be_immutable
class CategoriesPage extends StatefulWidget {
  late List<ListArticle> articleList;
  CategoriesPage({super.key, required this.articleList});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<CategoryModel> categories = [];
  List<ListArticle> likedList = [];
  @override
  void initState() {
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    likedList = arguments['articleList'] as List<ListArticle>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox(
          width: 420,
          // height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryTile(
                      image: categories[index].image!,
                      categoryName: categories[index].categoryName!,
                      likedList: likedList);
                },
              ))
            ],
          )),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/top_stories',
                arguments: {'articleList': likedList});
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/favorites',
                arguments: {'articleList': likedList});
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoryTile extends StatelessWidget {
  final categoryName, image;
  List<ListArticle> likedList;
  CategoryTile(
      {super.key, this.categoryName, this.image, required this.likedList});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/get_category',
            arguments: {'category': categoryName, "articleList": likedList});
      },
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    image,
                    width: 350,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 350,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black26,
                  ),
                  child: Center(
                      child: Text(categoryName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500))),
                )
              ],
            )),
      ),
    );
  }
}
