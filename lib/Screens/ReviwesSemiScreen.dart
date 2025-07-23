import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recommendation/Utils/MainColors.dart';
import 'package:recommendation/Utils/TextStyle.dart';

class ReviewsSemiScreen extends StatefulWidget {
  final String bookId;

  const ReviewsSemiScreen({super.key, required this.bookId});

  @override
  State<ReviewsSemiScreen> createState() => _ReviewsSemiScreenState();
}

class _ReviewsSemiScreenState extends State<ReviewsSemiScreen> {
  bool isExpanded = false;
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _submitComment() async {
    String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    final user = _auth.currentUser!;
    final userEmail = user.email!;
    final userName = user.displayName ?? 'Unknown';

    final existingCommentQuery =
        await _firestore
            .collection('Comments')
            .where('user_email', isEqualTo: userEmail)
            .where('book_id', isEqualTo: widget.bookId)
            .get();

    // Add new comment
    await _firestore.collection('Comments').add({
      'book_id': widget.bookId,
      'comment': commentText,
      'user_email': userEmail,
      'user_name': userName,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _commentController.clear();
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:
                _firestore
                    .collection('Comments')
                    .where('book_id', isEqualTo: widget.bookId)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                }
                return CircularProgressIndicator();
              }

              final allComments = snapshot.data!.docs;

              if (allComments.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "No comments yet.",
                    style: Text_Style.textStyleNormal(Colors.grey[700]!, 14),
                  ),
                );
              }

              final commentsToShow =
                  isExpanded ? allComments : allComments.take(2).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...commentsToShow.map((doc) {
                    final comment = doc['comment'] ?? '';
                    final name = doc['user_name'] ?? 'Anonymous';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Text_Style.textStyleBold(
                                MainColors.mainColor,
                                14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment,
                              style: Text_Style.textStyleNormal(
                                Colors.black.withOpacity(0.8),
                                15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (allComments.length > 2)
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? "Show Less" : "Show More",
                        style: Text_Style.textStyleBold(
                          MainColors.mainColor,
                          14,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: "Write your comment...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.send, color: MainColors.mainColor),
                onPressed: _submitComment,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
