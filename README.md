# 📚 Bookify App - Flutter

This Flutter application is a full-featured **Book Recommendation and Rental System** built for a technical challenge. It supports both user and admin roles and uses Firebase for backend functionality.

---

## 🚀 Features

### 👤 User
- 🔍 Search books by title or author
- 📚 View books by category
- 📖 Book details with rating and reviews
- ⭐ Submit, update, or remove your own rating
- 🛒 Rent available books
- ⏳ View rental history

### 🛠️ Admin
- 📋 Dashboard (AdminPanel)
- ➕ Add new books with Cloudinary image upload
- 📝 Edit existing book details
- 🗑️ Delete books
- 📦 Manage rental orders

---

## 🧠 Technologies Used

| Category        | Tech Stack                     |
|----------------|--------------------------------|
| Frontend       | Flutter                        |
| State Mgmt     | StatefulWidgets                |
| Backend        | Firebase Firestore             |
| Auth           | Firebase Authentication        |
| Storage        | Cloudinary (for book covers)   |
| Others         | HTTP, Provider (optional), Iconsax, Google Fonts, etc. |

---

## 📁 Folder Structure

lib/
├── Screens/ # All UI Screens
│ ├── HomeScreen.dart
│ ├── BookDetailsScreen.dart
│ ├── AddBookScreen.dart
│ ├── AdminEditBookScreen.dart
│ ├── AdminOrdersScreen.dart
│ └── UserRentalsScreen.dart
├── Services/ # Firebase interaction
│ ├── BooksServices.dart
│ └── RentalsService.dart
├── Utils/ # Colors, text styles, custom widgets
│ ├── MainColors.dart
│ ├── TextStyle.dart
│ └── TextFieldStyle.dart
├── main.dart # App entry point



---

## ⚙️ Firebase Configuration

This app requires:
- Firestore setup with `books` and `rentals` collections
- Firebase Authentication (email/password)
- Firestore security rules
- (Optional) Firebase Storage (not used since Cloudinary is integrated)

---

## 📷 Image Upload via Cloudinary

- Image is uploaded using HTTP Multipart request
- Cloudinary `unsigned` upload preset is used for simplicity
- Only available to admins when adding or editing books

---

## 📱 Screenshots

### Welcome Screen
<p align="center">
  <img src="Screenshots/WelcomeScreen.png" width="400" alt="Welcome Screen"/>
</p>

### Sign up Screen
<p align="center">
  <img src="Screenshots/SignUpScreen.png" width="400" alt="Signup Screen"/>
</p>

### Login Screen
<p align="center">
  <img src="Screenshots/LoginScreen.png" width="400" alt="Login Screen"/>
</p>

### Home Screen
<p align="center">
  <img src="Screenshots/UserHomeScreen.png" width="400" alt="Home Screen"/>
</p>

### Book Details
<p align="center">
  <img src="Screenshots/UserBookDetails.png" width="400" alt="Change Language"/>
</p>

###  Book Rental Screen
<p align="center">
  <img src="Screenshots/BookRentalScreen.png" width="400" alt="Change Language"/>
</p>


### Rental History Screen
<p align="center">
  <img src="Screenshots/RentalHistoryScreen.png" width="400" alt="Change Language"/>
</p>


### Admin Panel Screen
<p align="center">
  <img src="Screenshots/AdminPanel.png" width="400" alt="Change Language"/>
</p>


### Admin Mange Books Screen
<p align="center">
  <img src="Screenshots/AdminMangeBooks.png" width="400" alt="Change Language"/>
</p>


### Admin Add Book Screen
<p align="center">
  <img src="Screenshots/AdminAddBook.png" width="400" alt="Change Language"/>
</p>


### Admin Mange Orders Screen
<p align="center">
  <img src="Screenshots/AdminMangeOrders.png" width="400" alt="Change Language"/>
</p>


---

📅 Project Context
This app was developed as part of a technical challenge assigned to test Flutter & Firebase skills. The app is functional, well-structured, and styled for production-level use.

--- 

🧑‍💻 Developer
Mohamed Barakat
📧 Email: [mohamed.Barakat1166@gmail.com]
🔗 GitHub: [https://github.com/MagTaz]


