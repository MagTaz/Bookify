import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String title;
  final String author;
  final String coverImage;
  final String category;
  final String id;
  final String description;
  final bool available;

  Book({
    required this.title,
    required this.author,
    required this.coverImage,
    required this.category,
    required this.id,
    required this.description,
    required this.available,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      coverImage: data['coverImage'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      available: data['available'] ?? false,
    );
  }
}

class BooksService {
  Future<List<Book>> fetchBooks({
    String query = '',
    String category = '',
    String? excludeBookId,
  }) async {
    try {
      Query ref = FirebaseFirestore.instance
          .collection('books')
          .where('available', isEqualTo: true);

      if (category.isNotEmpty && category != 'All') {
        ref = ref.where('category', isEqualTo: category);
      }

      QuerySnapshot snapshot = await ref.get();

      List<Book> allBooks =
          snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();

      if (excludeBookId != null) {
        allBooks = allBooks.where((book) => book.id != excludeBookId).toList();
      }

      if (query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        allBooks =
            allBooks.where((book) {
              return book.title.toLowerCase().contains(lowerQuery) ||
                  book.author.toLowerCase().contains(lowerQuery);
            }).toList();
      }

      return allBooks;
    } catch (e) {
      print("Error fetching books: $e");
      return [];
    }
  }
}
