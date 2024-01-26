// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:projectapp/bussines/sign_in_bloc/sign_in_bloc.dart';
// import 'package:projectapp/presentation/home/drawer.dart';
import 'package:projectapp/presentation/home/home.dart';
import 'package:projectapp/presentation/recipedails/fullscreen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;

  // Przykładowa metoda do pobierania przepisu - na razie zwraca statyczne dane
  Recipe getRecipeById(String id) {
    // Tymczasowe przepisy - powinny być zastąpione danymi z bazy danych
    List<Recipe> recipes = [
      Recipe(id: '1', title: 'Przepis 1', description: 'Opis przepisu 1'),
      // Dodaj więcej przepisów
    ];
    return recipes.firstWhere((recipe) => recipe.id == id,
        orElse: () =>
            Recipe(id: '0', title: 'Nie znaleziono', description: ''));
  }

  RecipeDetailScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = getRecipeById(recipeId);

    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'recipe$recipeId',
              child: CircleAvatar(
                child: Text(recipe.title[0]), // pierwsza litera tytułu
                radius: 50.0,
              ),
            ),
            SizedBox(height: 20),
            Text(recipe.description),
            // Dodaj więcej szczegółów o przepisie
          ],
        ),
      ),
    );
  }
}

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;
  RecipeDetailPage({required this.recipeId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late var recipe;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    recipe = recipes.firstWhere((element) => element.id == widget.recipeId);
    // Jeżeli lista jest pusta lub nie znajdzie elementu, 'orElse' zwróci null
  }

  Color appBarColor = Colors.transparent;

  changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0) {
        setState(() {});
      }
      if (scrollController.position.pixels <= 2.0) {
        setState(() {
          appBarColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  // fab to write review
  showFAB(TabController tabController) {
    int reviewTabIndex = 2;
    if (tabController.index == reviewTabIndex) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          /// image
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                      image:
                          Image.asset('assets/food.png', fit: BoxFit.cover))));
            },
            child: Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/food.png'), fit: BoxFit.fill)),
              child: Container(
                height: 280,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          // Section 2 - Recipe Info
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
            color: Color.fromRGBO(255, 255, 255, 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Calories and Time
                Row(
                  children: [
                    Icon(Icons.alarm, size: 16, color: Colors.black),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        '10',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                // Recipe Title
                Container(
                  margin: EdgeInsets.only(bottom: 12, top: 16),
                  child: Text(
                    'TITLE',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'inter'),
                  ),
                ),
                // Recipe Description
                Text(
                  'description sdasdsadasd   asdasdasdasdas asdas d asd asd asdasd asd asd asd asdas das adsdasdasdas asd asdsasd asdas asd assdas sadasd as das dasd ass',
                  style: TextStyle(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                      fontSize: 16,
                      height: 150 / 100),
                ),
              ],
            ),
          ),
          // Tabbar ( Ingridients, Tutorial, Reviews )
          Container(
            color: Theme.of(context).primaryColor,
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.6),
              labelStyle:
                  TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w500),
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Ingridients',
                ),
                Tab(
                  text: 'Tutorial',
                ),
              ],
            ),
          ),
          // IndexedStack based on TabBar index
          IndexedStack(
            index: _tabController.index,
            children: [
              // Składniki
              ListView.builder(
                itemCount: 10, // przykładowa liczba składników
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Składnik ${index + 1}'),
                    subtitle: Text('Ilość: ${index + 1} szt'),
                  );
                },
              ),
              // Tutorials
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
