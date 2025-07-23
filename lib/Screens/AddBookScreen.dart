import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recommendation/Utils/TextFieldStyle.dart';
import '../Utils/MainColors.dart';
import '../Utils/TextStyle.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descController = TextEditingController();
  final _coverImageController = TextEditingController();
  String _selectedCategory = "Fiction";
  bool _isAvailable = true;
  bool _loading = false;
  File? _selectedImage;
  String? _uploadedImageUrl;
  final picker = ImagePicker();

  final List<String> _categories = [
    "Fiction",
    "Science",
    "History",
    "Technology",
    "Philosophy",
    "Psychology",
  ];
  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    final cloudName = 'dgzrnuhk0';
    final uploadPreset = 'unsigned';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStream = await http.Response.fromStream(response);
      final resData = json.decode(resStream.body);
      return resData['secure_url'];
    } else {
      throw Exception('Failed to upload image to Cloudinary');
    }
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      if (_selectedImage != null) {
        _uploadedImageUrl = await _uploadImage(_selectedImage!);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please select an image")));
        return;
      }

      await FirebaseFirestore.instance.collection('books').add({
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'description': _descController.text.trim(),
        'coverImage': _uploadedImageUrl,
        'category': _selectedCategory,
        'available': _isAvailable,
        'createdAt': DateTime.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Book added successfully')));
      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add book')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.mainColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Add Book",
          style: Text_Style.textStyleNormal(Colors.white, 23),
        ),
        backgroundColor: MainColors.mainColor,
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 15),
              _buildTextField(
                _titleController,
                "Title",
                icon: Icon(Iconsax.book_1),
              ),
              _buildTextField(
                _authorController,
                "Author",
                icon: Icon(Iconsax.user),
              ),
              _buildDropdown(),
              _buildTextField(
                _descController,
                "Description",
                maxLines: 3,
                icon: Icon(Iconsax.document_text),
              ),
              _buildImagePicker(),
              SwitchListTile(
                activeColor: MainColors.mainColor,
                title: Text("Available"),
                value: _isAvailable,
                onChanged: (val) {
                  setState(() => _isAvailable = val);
                },
              ),
              SizedBox(height: 16),
              _loading
                  ? Center(
                    child: SpinKitThreeBounce(
                      size: 30,
                      color: MainColors.mainColor,
                    ),
                  )
                  : ElevatedButton(
                    onPressed: _saveBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColors.mainColor,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      "Save Book",
                      style: Text_Style.textStyleBold(Colors.white, 18),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    required Icon icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: TextFieldStyle().SecondTextField(
          label,
          icon,
          MainColors.mainColor,
        ),

        validator:
            (val) => val == null || val.trim().isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Book Cover",
            style: Text_Style.textStyleBold(Colors.black87, 16),
          ),
          SizedBox(height: 10),
          _selectedImage != null
              ? Center(
                child: Stack(
                  children: [
                    Image.file(_selectedImage!, height: 150),
                    Positioned(
                      top: 1,
                      right: 1,
                      child: InkResponse(
                        onTap: _pickImage,
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
              )
              : InkResponse(
                onTap: _pickImage,
                child: Center(
                  child: Container(
                    height: 150,
                    width: 120,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        focusColor: MainColors.mainColor,
        decoration: InputDecoration(
          labelText: "Category",
          labelStyle: Text_Style.textStyleNormal(MainColors.mainColor, 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MainColors.mainColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: MainColors.mainColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MainColors.mainColor, width: 2),
          ),
        ),
        items:
            _categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
        onChanged: (val) => setState(() => _selectedCategory = val!),
      ),
    );
  }
}
