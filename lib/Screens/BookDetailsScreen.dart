import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recommendation/Screens/BookRentalScreen.dart';
import 'package:recommendation/Screens/DescriptionSemiScreen.dart';
import 'package:recommendation/Screens/RecommendationsSemiScreen.dart';
import 'package:recommendation/Screens/ReviwesSemiScreen.dart';
import 'package:recommendation/Services/BooksServices.dart';
import 'package:recommendation/Utils/MainColors.dart';
import 'package:recommendation/Utils/TextStyle.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key, required this.book});
  final Book book;

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int activeIndex = 0;
  double rating = 0;
  bool loadingRate = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double averageRating = 0.0;
  bool hasActiveRental = false;
  bool loadingRentalCheck = true;

  Future<void> checkActiveRental() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot =
          await _firestore
              .collection('rentals')
              .where('user_id', isEqualTo: user.uid)
              .where('book_id', isEqualTo: widget.book.id)
              .where('status', whereIn: ['pending', 'approved'])
              .get();

      setState(() {
        hasActiveRental = snapshot.docs.isNotEmpty;
        loadingRentalCheck = false;
      });
    } catch (e) {
      print('Error checking active rental: $e');
      setState(() => loadingRentalCheck = false);
    }
  }

  Future<void> fetchExistingRating() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        QuerySnapshot existingRatingQuery =
            await _firestore
                .collection('Reviews')
                .where('book_id', isEqualTo: widget.book.id)
                .where('user_email', isEqualTo: user.email)
                .get();

        if (existingRatingQuery.docs.isNotEmpty) {
          DocumentSnapshot existingRating = existingRatingQuery.docs.first;
          setState(() {
            rating = existingRating['rating'].toDouble();
          });
        }
      } catch (e) {
        print("Error fetching rating: $e");
      }
    }
  }

  Future<void> saveRatingToFirestore(double rating) async {
    final User? user = _auth.currentUser;
    setState(() {
      loadingRate = true;
    });

    if (user != null) {
      try {
        QuerySnapshot existingRatingQuery =
            await _firestore
                .collection('Reviews')
                .where('book_id', isEqualTo: widget.book.id)
                .where('user_email', isEqualTo: user.email)
                .get();

        if (existingRatingQuery.docs.isEmpty) {
          await _firestore.collection('Reviews').add({
            'book_id': widget.book.id, // Book ID
            'user_email': user.email, // User email
            'user_name': user.displayName, // User name
            'rating': rating, // Rating value
            'timestamp': FieldValue.serverTimestamp(), // Timestamp
            'Comment': "",
          });

          print("Rating saved successfully");
        } else {
          DocumentSnapshot existingRating = existingRatingQuery.docs.first;
          await _firestore.collection('Reviews').doc(existingRating.id).update({
            'rating': rating,
            'timestamp': FieldValue.serverTimestamp(),
          });

          print("Rating updated successfully");
        }

        setState(() {
          loadingRate = false;
        });
      } catch (e) {
        print("Error saving rating: $e");
        setState(() {
          loadingRate = false;
        });
      }
    } else {
      print("No user is signed in");
      setState(() {
        loadingRate = false;
      });
    }
  }

  Future<void> deleteRatingFromFirestore() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        QuerySnapshot existingRatingQuery =
            await _firestore
                .collection('Reviews')
                .where('book_id', isEqualTo: widget.book.id)
                .where('user_email', isEqualTo: user.email)
                .get();

        if (existingRatingQuery.docs.isNotEmpty) {
          DocumentSnapshot existingRating = existingRatingQuery.docs.first;
          await _firestore
              .collection('Reviews')
              .doc(existingRating.id)
              .delete();

          print("Rating deleted successfully");
        }
      } catch (e) {
        print("Error deleting rating: $e");
      }
    } else {
      print("No user is signed in");
    }
  }

  Future<void> fetchAverageRating() async {
    try {
      QuerySnapshot ratingsSnapshot =
          await _firestore
              .collection('Reviews')
              .where('book_id', isEqualTo: widget.book.id)
              .get();

      if (ratingsSnapshot.docs.isNotEmpty) {
        double total = 0;
        int count = 0;

        for (var doc in ratingsSnapshot.docs) {
          if (doc['rating'] != null) {
            total += doc['rating'];
            count++;
          }
        }

        setState(() {
          averageRating = count > 0 ? total / count : 0.0;
        });
      }
    } catch (e) {
      print("Error fetching average rating: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    checkActiveRental();
    fetchExistingRating();
    fetchAverageRating();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    Book book = widget.book;
    print(book.category);
    List<Widget> SemiScreens = [
      DescriptionSemiScreen(description: book.description),
      ReviewsSemiScreen(bookId: book.id),
    ];
    List<String> TextsList = ["Synopsis", "Reviews"];

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Container(
              height: heightScreen * 0.5,
              width: widthScreen,
              child: Image.network(book.coverImage, fit: BoxFit.cover),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
              child: Container(
                height: heightScreen * 0.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white30, Colors.white30, Colors.white],
                  ),
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 5),

            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Center(
                        child: Container(
                          height: heightScreen * 0.22,
                          width: widthScreen * 0.3,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 5,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                          child: Image.network(
                            book.coverImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: widthScreen * 0.8,
                        ),
                        child: Text(
                          book.title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: Text_Style.textStyleBold(Colors.black, 20),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: widthScreen * 0.8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              averageRating.toStringAsFixed(1),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Text_Style.textStyleNormal(
                                Colors.black54,
                                16,
                              ),
                            ),
                            Icon(Icons.star, color: Colors.amber),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      rating < 1
                          ? Text(
                            "Rate It",
                            style: Text_Style.textStyleNormal(
                              Colors.black87,
                              16,
                            ),
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "My Rate",
                                style: Text_Style.textStyleNormal(
                                  Colors.black87,
                                  16,
                                ),
                              ),
                              Icon(Icons.check, color: Colors.green),
                            ],
                          ),
                      Container(
                        height: 50,
                        child:
                            loadingRate == false
                                ? RatingBar.builder(
                                  initialRating: rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  itemBuilder:
                                      (context, _) =>
                                          Icon(Icons.star, color: Colors.amber),
                                  onRatingUpdate: (ratingValue) {
                                    setState(() {
                                      if (rating == ratingValue) {
                                        rating = 0;

                                        deleteRatingFromFirestore();
                                      } else {
                                        rating = ratingValue;

                                        saveRatingToFirestore(ratingValue);
                                      }
                                    });
                                  },
                                )
                                : Center(
                                  child: SpinKitThreeBounce(
                                    size: 30,
                                    color: MainColors.mainColor,
                                  ),
                                ),
                      ),
                      Container(
                        width: widthScreen,
                        height: 38,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.topCenter,
                        child: Center(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,

                            itemCount: TextsList.length,
                            itemBuilder: (context, index) {
                              return Material(
                                color: Colors.transparent,
                                child: InkResponse(
                                  onTap: () {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        TextsList[index],
                                        style:
                                            activeIndex == index
                                                ? Text_Style.textStyleBold(
                                                  MainColors.mainColor,
                                                  16,
                                                )
                                                : Text_Style.textStyleNormal(
                                                  Colors.black.withValues(
                                                    alpha: 0.5,
                                                  ),
                                                  16,
                                                ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: (widthScreen - 20) / 2,
                                        height: activeIndex == index ? 3 : 1,
                                        color:
                                            activeIndex == index
                                                ? MainColors.mainColor
                                                : Colors.black45,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SemiScreens[activeIndex],
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Text(
                              "Recommendations",
                              style: Text_Style.textStyleBold(
                                MainColors.mainColor,
                                20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RecommendationsSemiScreens(
                        category: book.category,
                        bookName: book.title.split(" ").first,
                        bookId: book.id,
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child:
                loadingRentalCheck
                    ? Center(
                      child: SpinKitThreeBounce(
                        size: 30,
                        color: MainColors.mainColor,
                      ),
                    )
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColors.mainColor,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed:
                          hasActiveRental
                              ? null
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            BookRentalScreen(book: widget.book),
                                  ),
                                );
                              },
                      child: Text(
                        hasActiveRental ? "Already Rented" : ' Rent ',
                        style: Text_Style.textStyleBold(Colors.white, 18),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
