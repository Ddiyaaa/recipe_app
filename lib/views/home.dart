import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipie_app/model/recipie_model.dart';
import 'package:recipie_app/views/recipe_details.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();
  List<RecipeModel> recipes = [];
  bool isLoading = false;
  int _selectedIndex = 0;

  void getRecipes(String query) async {
    recipes = [];
    setState(() {
      isLoading = true; // Show loading indicator
    });
    var url = "https://api.edamam.com/search?q=$query&app_id=2e7f2a2c&app_key=f41c48a5f8f49050706bdf0c05152bc6";
    print("Fetching recipes from: $url");
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(jsonData); // Print API response to console

        if (jsonData["hits"] != null) {
          jsonData["hits"].forEach((element) {
            RecipeModel recipeModel = RecipeModel.fromMap(element['recipe']);
            recipes.add(recipeModel);
          });

          setState(() {
            isLoading = false; // Hide loading indicator
          });
        }
      } else {
        print("Failed to fetch recipes");
        setState(() {
          isLoading = false; // Hide loading indicator
        });
      }
    } catch (e) {
      print("Error fetching recipes: $e");
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  Widget recipeGrid() {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: GridView.builder(
        padding: EdgeInsets.only(top: 16),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 25,
          crossAxisSpacing: 30,
          crossAxisCount: 2,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeTile(
            imgUrl: recipes[index].image,
            label: recipes[index].label,
            recipeDetailsUrl: recipes[index].url,
            source: recipes[index].source,
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle category selection
    switch (index) {
      case 0:
      // All recipes
        getRecipes('Lunch');
        break;
      case 1:
      // Vegetarian
        getRecipes('Breakfast');
        break;
      case 2:
      // Desserts
        getRecipes('desserts');
        break;
      case 3:
      // Snacks
        getRecipes('snacks');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [

                  const Color(0xff4ca0e9),
                  const Color(DateTime.april),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 70, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "COOK ",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily:'RemachineScript'

                      ),
                    ),
                    Image.asset(
                      'assets/chefbg.png',
                      alignment: Alignment.center,
                      height: 60, // Adjust the height to fit your design
                      width: 90, // Adjust the width to fit your design
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10), // Add some spacing between the image and the text
                    Text(
                      "BOOK",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                          fontFamily:'RemachineScript'
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text(
                  "What will you Cook Today?",
                  style: TextStyle(fontSize: 23, color: Colors.black,fontFamily:'Movistar'
                  ,fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  "Just Enter Ingredients you have and we will show the best recipe for you",
                  style: TextStyle(fontSize: 17, color: Colors.black,fontFamily: 'Movistar'),
                ),
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: "Enter Ingredients",
                          hintStyle: TextStyle(fontSize: 18,fontFamily: 'ReamchineScript',fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        getRecipes(textEditingController.text);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : recipes.isNotEmpty
                    ? recipeGrid()
                    : Container(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Lunch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.breakfast_dining_outlined),
            label: 'BreakFast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            label: 'Desserts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Snacks',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xffbe4e29),
        unselectedItemColor: Colors.white,
        backgroundColor: Color(0xff213A50),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final String label, source, imgUrl, recipeDetailsUrl;

  RecipeTile({
    required this.imgUrl,
    required this.label,
    required this.recipeDetailsUrl,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipeDetailsUrl: recipeDetailsUrl),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        child: Stack(
          children: [
            Image.network(
              imgUrl,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Center(
                  child: Icon(Icons.error),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      source,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
