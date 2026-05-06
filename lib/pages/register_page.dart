import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController userNameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController profileController =
  TextEditingController();

  bool isLoading = false;

  bool isPasswordVisible = false;

  Future<void> registerUser() async {

    if (userNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Please fill all required fields",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      // Firebase Authentication
      UserCredential userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(

        email: emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // Save User Details
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .set({

        "uid": uid,

        "userName":
        userNameController.text.trim(),

        "email":
        emailController.text.trim(),

        "phoneNumber":
        phoneController.text.trim(),

        "image":
        profileController.text.trim(),

        "status":
        "Hey there! I am using WhatsApp",

        "createdAt":
        Timestamp.now(),
      });

      // Save in allContacts
      await FirebaseFirestore.instance
          .collection("allContacts")
          .doc(uid)
          .set({

        "uid": uid,

        "phoneNumber":
        phoneController.text.trim(),
      });

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Registration Successful",
          ),
        ),
      );

      // Navigate Login Page
      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (context) =>
          const LoginPage(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            e.message ??
                "Registration Failed",
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

              const SizedBox(height: 25),

              // Logo
              Container(

                padding: const EdgeInsets.all(28),

                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Colors.green.shade500,
                ),
              ),

              const SizedBox(height: 30),

              // Title
              const Text(

                "Create Account",

                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(

                "Register to start chatting",

                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 40),

              // Username Field
              buildTextField(

                controller: userNameController,

                hintText: "Username",

                icon: Icons.person,
              ),

              const SizedBox(height: 18),

              // Email Field
              buildTextField(

                controller: emailController,

                hintText: "Email Address",

                icon: Icons.email,

                keyboardType:
                TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

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

                  controller:
                  passwordController,

                  obscureText:
                  !isPasswordVisible,

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

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                      borderSide:
                      BorderSide.none,
                    ),

                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Phone Field
              buildTextField(

                controller: phoneController,

                hintText: "Phone Number",

                icon: Icons.phone,

                keyboardType:
                TextInputType.phone,
              ),

              const SizedBox(height: 18),

              // Profile URL Field
              buildTextField(

                controller: profileController,

                hintText:
                "Profile Image URL (Optional)",

                icon: Icons.image,
              ),

              const SizedBox(height: 40),

              // Register Button
              SizedBox(

                width: double.infinity,
                height: 58,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.green,

                    elevation: 0,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),

                  onPressed:
                  isLoading ? null : registerUser,

                  child: isLoading

                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )

                      : const Row(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Icon(
                        Icons.app_registration,
                        color: Colors.white,
                      ),

                      SizedBox(width: 10),

                      Text(

                        "Register",

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

              const SizedBox(height: 28),

              // Login Navigation
              Row(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Text(

                    "Already have an account?",

                    style: TextStyle(
                      color:
                      Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),

                  TextButton(

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                          const LoginPage(),
                        ),
                      );
                    },

                    child: const Text(

                      "Login",

                      style: TextStyle(
                        color: Colors.green,
                        fontWeight:
                        FontWeight.bold,
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

  // Custom TextField Widget
  Widget buildTextField({

    required TextEditingController controller,

    required String hintText,

    required IconData icon,

    TextInputType keyboardType =
        TextInputType.text,
  }) {

    return Container(

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

        controller: controller,

        keyboardType: keyboardType,

        decoration: InputDecoration(

          prefixIcon: Icon(
            icon,
            color: Colors.green,
          ),

          hintText: hintText,

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),

          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}