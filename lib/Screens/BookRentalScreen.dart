import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Utils/MainColors.dart';
import '../Utils/TextStyle.dart';
import '../Services/BooksServices.dart';

class BookRentalScreen extends StatefulWidget {
  final Book book;

  const BookRentalScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BookRentalScreen> createState() => _BookRentalScreenState();
}

class _BookRentalScreenState extends State<BookRentalScreen> {
  DateTime? rentalDate;
  DateTime? returnDate;
  bool loading = false;

  Future<void> pickRentalDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(Duration(days: 60)),
    );

    if (picked != null) {
      setState(() {
        rentalDate = picked;
        returnDate = null;
      });
    }
  }

  Future<void> pickReturnDate() async {
    if (rentalDate == null) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: rentalDate!.add(Duration(days: 1)),
      firstDate: rentalDate!.add(Duration(days: 1)),
      lastDate: rentalDate!.add(Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        returnDate = picked;
      });
    }
  }

  Future<void> confirmBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || rentalDate == null || returnDate == null) return;

    setState(() => loading = true);

    try {
      final now = DateTime.now();

      await FirebaseFirestore.instance.collection('rentals').add({
        'book_id': widget.book.id,
        'book_title': widget.book.title,
        'user_id': user.uid,
        'user_email': user.email,
        'rental_date': rentalDate,
        'return_date': returnDate,
        'status': 'pending',
        'timestamp': now,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The request has been sent successfully.')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while sending the request.')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Container(
              height: heightScreen * 0.5,
              width: widthScreen,
              child: Image.network(widget.book.coverImage, fit: BoxFit.cover),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    widget.book.title,
                    style: Text_Style.textStyleBold(MainColors.mainColor, 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
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
                        widget.book.coverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 80),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: widthScreen / 2 - 40,
                        height: 75,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MainColors.mainColor,
                            padding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: pickRentalDate,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.date_range, color: Colors.white),
                                Text(
                                  rentalDate == null
                                      ? 'Select rental date'
                                      : 'Rental date \n ${rentalDate!.toLocal().toString().split(' ')[0]}',
                                  style: Text_Style.textStyleNormal(
                                    Colors.white,
                                    15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: widthScreen / 2 - 40,
                        height: 75,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MainColors.mainColor,
                            padding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          onPressed: rentalDate == null ? null : pickReturnDate,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              children: [
                                Icon(Icons.date_range, color: Colors.white),
                                Text(
                                  returnDate == null
                                      ? 'Select return date'
                                      : 'Return Date \n ${returnDate!.toLocal().toString().split(' ')[0]}',
                                  style: Text_Style.textStyleNormal(
                                    Colors.white,
                                    15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  loading
                      ? Center(
                        child: SpinKitThreeBounce(
                          size: 30,
                          color: MainColors.mainColor,
                        ),
                      )
                      : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              (rentalDate != null && returnDate != null)
                                  ? confirmBooking
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MainColors.mainColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                          ),
                          child: Text(
                            'Confirm Booking',
                            style: Text_Style.textStyleBold(Colors.white, 18),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
