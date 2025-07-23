import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:recommendation/Screens/BookDetailsScreen.dart';
import 'package:recommendation/Screens/UserRentalsScreen.dart';
import 'package:recommendation/Screens/WelcomeScreen.dart';
import 'package:recommendation/Services/BooksServices.dart';
import 'package:recommendation/Utils/MainColors.dart';
import 'package:recommendation/Utils/TextStyle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BooksService booksService = BooksService();
  late Future<List<Book>> books;
  TextEditingController _searchTextController = TextEditingController();

  List<String> categories = [
    "All",
    "Fiction",
    "Science",
    "History",
    "Technology",
    "Philosophy",
    "Psychology",
  ];
  int selectedIndex = 0;
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    books = booksService.fetchBooks();
  }

  void searchBooks(String query) {
    setState(() {
      books = booksService.fetchBooks(query: query);
    });
  }

  void filterBooks(String category, int index) {
    setState(() {
      selectedIndex = index;
      selectedCategory = category;
      books = booksService.fetchBooks(
        query: _searchTextController.text,
        category: category,
      );
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            enabled: false,
                            child: Text(
                              "${user!.displayName}",
                              style: Text_Style.textStyleBold(
                                Colors.black45,
                                16,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Rental History',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Rental History",
                                  style: Text_Style.textStyleNormal(
                                    MainColors.mainColor,
                                    15,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.history,
                                  color: MainColors.mainColor.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),

                          PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Sign out",
                                  style: Text_Style.textStyleNormal(
                                    MainColors.mainColor,
                                    15,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Iconsax.logout_1_copy,
                                  color: MainColors.mainColor.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == 'logout') {
                          _auth.signOut();
                          setState(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeScreen(),
                              ),
                              ((route) => false),
                            );
                          });
                        }
                        if (value == 'Rental History') {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserRentalsScreen(),
                              ),
                            );
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 19,
                        backgroundColor: MainColors.mainColor.withValues(
                          alpha: 0.4,
                        ),
                        child: Center(
                          child: Text(
                            user!.displayName.toString()[0].toUpperCase(),
                            style: Text_Style.textStyleBold(Colors.black45, 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Welcome ${user!.displayName}",
                      style: Text_Style.textStyleBold(Colors.black54, 20),
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 35),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 50,
              child: TextField(
                controller: _searchTextController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MainColors.mainColor.withValues(alpha: 0.2),
                  hintText: "Search",
                  hintStyle: Text_Style.textStyleNormal(Colors.black45, 17),
                  prefixIcon: Icon(Iconsax.search_normal_copy),
                  prefixIconColor: Colors.black45,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      width: 1.9,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    searchBooks(value);
                  } else {
                    setState(() {
                      books = booksService.fetchBooks();
                    });
                  }
                },
              ),
            ),
            Container(
              height: 100,
              margin: EdgeInsets.only(left: 15),
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap:
                        () => filterBooks(
                          index == 0 ? "" : categories[index],
                          index,
                        ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [],
                        color:
                            selectedIndex == index
                                ? MainColors.mainColor
                                : MainColors.mainColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style:
                              selectedIndex != index
                                  ? Text_Style.textStyleNormal(
                                    Colors.black38,
                                    16,
                                  )
                                  : Text_Style.textStyleBold(Colors.white, 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: books,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: MainColors.mainColor,
                        size: 50,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading books"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No books available"));
                  } else {
                    return GridView.builder(
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var book = snapshot.data![index];
                        return InkResponse(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BookDetailsScreen(book: book),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: heightScreen * 0.3,
                                  width: widthScreen * 0.4,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        spreadRadius: 3,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                  child: Image.network(
                                    book.coverImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  constraints: BoxConstraints(
                                    maxWidth: widthScreen * 0.37,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        book.title,
                                        maxLines: 2,
                                        style: Text_Style.textStyleNormal(
                                          Colors.black54,
                                          18,
                                        ),
                                      ),
                                      Text(
                                        " (${book.author}) ",
                                        maxLines: 1,
                                        style: Text_Style.textStyleNormal(
                                          Colors.black54,
                                          14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
