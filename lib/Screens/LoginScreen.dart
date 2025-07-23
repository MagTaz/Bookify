// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recommendation/Screens/AdminPanelScreen.dart';
import 'package:recommendation/Screens/AdminOrdersScreen.dart';
import 'package:recommendation/Screens/HomeScreen.dart';
import 'package:recommendation/Screens/SignupScreen.dart';
import 'package:recommendation/Services/UserServices.dart';
import 'package:recommendation/Utils/MainColors.dart';
import 'package:recommendation/Widgets/LoginAnimation.dart';

import '../Utils/ButtonStyle.dart';
import '../Utils/Fonts.dart';
import '../Utils/TextFieldStyle.dart';
import '../Utils/TextStyle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/background.jpg",
              fit: BoxFit.cover,
              width: widthScreen,
              height: heightScreen,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      MainColors.mainColor.withValues(alpha: 0.2),

                      Colors.black45,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),

            // Container(width: widthScreen, child: const LoginAnimation()),
            Container(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Container(
                padding: EdgeInsets.all(40),
                height: heightScreen,
                width: widthScreen,
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: widthScreen * 0.3,

                            child: Image.asset("assets/images/logo.png"),
                          ),

                          SizedBox(height: 120),

                          emailTextField(MainColors.mainColor),
                          SizedBox(height: 30),
                          passwordTextField(MainColors.mainColor),
                          SizedBox(height: 30),
                          ElevatedButton(
                            style: Button_Style.buttonStyle(
                              context,
                              MainColors.mainColor,
                              12,
                            ),
                            onPressed:
                                _isLoading == true
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        UserServices()
                                            .Login(
                                              emailController.text.trim(),
                                              passwordController.text.trim(),
                                            )
                                            .then((value) {
                                              if (value != null) {
                                                if (emailController.text ==
                                                    "admin@gmail.com") {
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              AdminPanelScreen(),
                                                    ),
                                                    ((route) => false),
                                                  );
                                                } else {
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              HomeScreen(),
                                                    ),
                                                    ((route) => false),
                                                  );
                                                }
                                                setState(() {
                                                  _isLoading = false;
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      content: Text(
                                                        "You are logged in",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });

                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  _isLoading = false;
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        "invalid password or email",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                              }
                                            });
                                      }
                                    },
                            child:
                                _isLoading == true
                                    ? Center(
                                      child: SpinKitThreeBounce(
                                        size: 30,
                                        color: MainColors.mainColor,
                                      ),
                                    )
                                    : Text(
                                      "Login",
                                      style: Text_Style.textBoldStyle,
                                    ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: widthScreen * 0.35,
                            child: Divider(color: Colors.black26, height: 1),
                          ),
                          InkResponse(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              width: widthScreen,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: Text_Style.textStyleNormal(
                                      Colors.white.withOpacity(0.8),
                                      16,
                                    ),
                                  ),

                                  Text(
                                    " Sign up",
                                    style: Text_Style.textStyleBold(
                                      MainColors.mainColor,
                                      16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField emailTextField(Color color) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an email';
        } else if (!RegExp(
          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
        ).hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      style: Text_Style.textStyleNormal(Colors.white70, 18),
      enabled: !_isLoading,
      controller: emailController,
      obscureText: false,
      decoration: TextFieldStyle().primaryTextField(
        "Email",
        Icon(Icons.email),
        color,
      ),
    );
  }

  TextFormField passwordTextField(Color color) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Empty Password";
        }
        return null;
      },
      style: Text_Style.textStyleNormal(Colors.white70, 18),
      enabled: !_isLoading,
      controller: passwordController,
      obscureText: true,
      decoration: TextFieldStyle().primaryTextField(
        "Password",
        Icon(Icons.lock),
        color,
      ),
    );
  }
}
