import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recommendation/Screens/BookDetailsScreen.dart';
import 'package:recommendation/Services/BooksServices.dart';
import 'package:recommendation/Utils/MainColors.dart';
import 'package:recommendation/Utils/TextStyle.dart';

class RecommendationsSemiScreens extends StatefulWidget {
  const RecommendationsSemiScreens({
    super.key,
    required this.category,
    required this.bookName,
    required this.bookId,
  });

  final String category;
  final String bookName;
  final String bookId;
  @override
  State<RecommendationsSemiScreens> createState() =>
      _RecommendationsSemiScreensState();
}

final BooksService booksService = BooksService();
late Future<List<Book>> books;

class _RecommendationsSemiScreensState
    extends State<RecommendationsSemiScreens> {
  void initState() {
    super.initState();
    books = booksService.fetchBooks(
      query: "",
      category: widget.category,
      excludeBookId: widget.bookId,
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Container(
      height: heightScreen * 0.22,
      width: widthScreen,
      child: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCircle(color: MainColors.mainColor, size: 50),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading books"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                books = booksService.fetchBooks(
                  query: widget.bookName,
                  category: "",
                  excludeBookId: widget.bookId,
                );
              });
            });
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: SpinKitFadingCircle(
                  color: MainColors.mainColor,
                  size: 50,
                ),
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,

              itemCount:
                  snapshot.data!.length > 10 ? 10 : snapshot.data!.length,

              itemBuilder: (context, index) {
                var book = snapshot.data![index];
                return InkResponse(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(book: book),
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: heightScreen * 0.15,
                          width: widthScreen * 0.25,
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
                          margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                          constraints: BoxConstraints(
                            maxWidth: widthScreen * 0.25,
                          ),
                          child: Text(
                            book.title,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: Text_Style.textStyleNormal(
                              Colors.black54,

                              14,
                            ),
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
    );
    ;
  }
}
