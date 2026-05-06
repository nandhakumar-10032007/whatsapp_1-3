import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool isLoading = false;

  bool isPasswordVisible = false;

  Future<void> loginUser() async {

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Please enter email and password",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      // Firebase Login
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email: emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("Login Successful"),
        ),
      );

      // Navigate to Home Page
      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (context) =>
          const HomePage(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            e.message ?? "Login Failed",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FA),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(22),

          child: Column(

            children: [

              const SizedBox(height: 40),

              // Logo
              Container(

                padding: const EdgeInsets.all(30),

                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.chat,
                  size: 90,
                  color: Colors.green.shade500,
                ),
              ),

              const SizedBox(height: 35),

              // Title
              const Text(

                "Welcome Back",

                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(

                "Login to continue chatting",

                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 45),

              // Email Field
              Container(

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(18),

                  boxShadow: [

                    BoxShadow(
                      color:
                      Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: TextField(

                  controller: emailController,

                  keyboardType:
                  TextInputType.emailAddress,

                  style: const TextStyle(
                    fontSize: 16,
                  ),

                  decoration: InputDecoration(

                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.green,
                    ),

                    hintText: "Email Address",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),

                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              Container(

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(18),

                  boxShadow: [

                    BoxShadow(
                      color:
                      Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: TextField(

                  controller: passwordController,

                  obscureText: !isPasswordVisible,

                  style: const TextStyle(
                    fontSize: 16,
                  ),

                  decoration: InputDecoration(

                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.green,
                    ),

                    suffixIcon: IconButton(

                      onPressed: () {

                        setState(() {
                          isPasswordVisible =
                          !isPasswordVisible;
                        });
                      },

                      icon: Icon(

                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,

                        color: Colors.grey,
                      ),
                    ),

                    hintText: "Password",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),

                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Forgot Password
              Align(

                alignment: Alignment.centerRight,

                child: TextButton(

                  onPressed: () {},

                  child: const Text(

                    "Forgot Password?",

                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Login Button
              SizedBox(

                width: double.infinity,
                height: 58,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.green,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),

                  onPressed:
                  isLoading ? null : loginUser,

                  child: isLoading

                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )

                      : const Row(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Icon(
                        Icons.login,
                        color: Colors.white,
                      ),

                      SizedBox(width: 10),

                      Text(

                        "Login",

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Register
              Row(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Text(

                    "Don't have an account?",

                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),

                  TextButton(

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                          const RegisterPage(),
                        ),
                      );
                    },

                    child: const Text(

                      "Register",

                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}