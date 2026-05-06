import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  bool isLoading = false;

  final String currentUserUid =
      FirebaseAuth.instance.currentUser!.uid;

  Future<void> addContact() async {

    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      // Check Number in allContacts
      QuerySnapshot contactSnapshot =
      await FirebaseFirestore.instance
          .collection("allContacts")
          .where(
        "phoneNumber",
        isEqualTo: phoneController.text.trim(),
      )
          .get();

      // User Not Registered
      if (contactSnapshot.docs.isEmpty) {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "This number is not registered",
            ),
          ),
        );

        return;
      }

      // Registered User Data
      var allContactData =
      contactSnapshot.docs.first.data()
      as Map<String, dynamic>;

      String contactUid =
      allContactData["uid"];

      // Prevent Self Add
      if (contactUid == currentUserUid) {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "You cannot add yourself",
            ),
          ),
        );

        return;
      }

      // Get Full User Details
      DocumentSnapshot userDocument =
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(contactUid)
          .get();

      var userData =
      userDocument.data()
      as Map<String, dynamic>;

      // Store Contact
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserUid)
          .collection("contacts")
          .doc(contactUid)
          .set({

        "uid": contactUid,
        "userName": nameController.text.trim(),
        "phoneNumber": userData["phoneNumber"],
        "email": userData["email"],
        "image": userData["image"],
        "status": userData["status"],
        "createdAt": Timestamp.now(),

      });

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Contact Added Successfully",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(

        elevation: 0,
        backgroundColor: Colors.white,

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        title: const Text(

          "Add Contact",

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 20),

            // Top Icon
            Container(

              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.person_add_alt_1,
                size: 70,
                color: Colors.green.shade500,
              ),
            ),

            const SizedBox(height: 30),

            const Text(

              "Add New Contact",

              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(

              "Enter registered phone number",

              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 40),

            // Contact Name Field
            Container(

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(18),

                boxShadow: [

                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: TextField(

                controller: nameController,

                style: const TextStyle(
                  fontSize: 16,
                ),

                decoration: InputDecoration(

                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.green,
                  ),

                  hintText: "Contact Name",

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

            // Phone Number Field
            Container(

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(18),

                boxShadow: [

                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: TextField(

                controller: phoneController,

                keyboardType: TextInputType.phone,

                style: const TextStyle(
                  fontSize: 16,
                ),

                decoration: InputDecoration(

                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.green,
                  ),

                  hintText: "Phone Number",

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

            const SizedBox(height: 45),

            // Add Contact Button
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
                isLoading ? null : addContact,

                child: isLoading

                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )

                    : const Row(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),

                    SizedBox(width: 10),

                    Text(

                      "Add Contact",

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
          ],
        ),
      ),
    );
  }
}