import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recommendation/Screens/AddBookScreen.dart';
import 'package:recommendation/Screens/AdminEditBookScreen.dart';
import '../Utils/MainColors.dart';
import '../Utils/TextStyle.dart';

class AdminBooksScreen extends StatelessWidget {
  const AdminBooksScreen({super.key});

  Future<void> deleteBook(String bookId) async {
    await FirebaseFirestore.instance.collection('books').doc(bookId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.mainColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Manage Books",
          style: Text_Style.textStyleNormal(Colors.white, 23),
        ),
        backgroundColor: MainColors.mainColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddBookScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 5),
          ],
        ),
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('books').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
              return Center(child: Text("No books found."));

            final books = snapshot.data!.docs;

            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final data = books[index].data() as Map<String, dynamic>;
                final id = books[index].id;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading:
                        data['coverImage'] != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['coverImage'],
                                width: 50,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Icon(Icons.book, size: 50, color: Colors.grey),
                    title: Text(
                      data['title'] ?? 'Untitled',
                      style: Text_Style.textStyleBold(Colors.black87, 17),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text("Author: ${data['author'] ?? 'Unknown'}"),
                        Text(
                          "Available: ${data['available'] == true ? 'Yes' : 'No'}",
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkResponse(
                          child: Icon(Icons.edit, size: 20, color: Colors.blue),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AdminEditBookScreen(
                                      bookDoc: books[index],
                                    ),
                              ),
                            );
                          },
                        ),
                        InkResponse(
                          child: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    title: Text("Delete Book"),
                                    content: Text(
                                      "Are you sure you want to delete this book?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          "Cancel",
                                          style: Text_Style.textStyleNormal(
                                            MainColors.mainColor,
                                            16,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: MainColors.mainColor,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                        ),
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: Text(
                                          "Delete",
                                          style: Text_Style.textStyleNormal(
                                            Colors.white,
                                            16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm == true) {
                              await deleteBook(id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
