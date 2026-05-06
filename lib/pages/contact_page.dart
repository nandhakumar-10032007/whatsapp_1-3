import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final String currentUserId =
      FirebaseAuth.instance.currentUser!.uid;

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

          "Contacts",

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUserId)
            .collection("contacts")
            .snapshots(),

        builder: (context, snapshot) {

          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // No Contacts
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return Center(

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Container(

                    padding: const EdgeInsets.all(30),

                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.contacts,
                      size: 90,
                      color: Colors.green.shade400,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "No Contacts Found",

                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Add contacts to start chatting",

                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          // Contact List
          var contacts = snapshot.data!.docs;

          return ListView.builder(

            padding: const EdgeInsets.only(
              top: 10,
              bottom: 15,
            ),

            itemCount: contacts.length,

            itemBuilder: (context, index) {

              var contact =
              contacts[index].data()
              as Map<String, dynamic>;

              return Padding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                child: Material(

                  elevation: 1.5,

                  borderRadius:
                  BorderRadius.circular(18),

                  color: Colors.white,

                  child: InkWell(

                    borderRadius:
                    BorderRadius.circular(18),

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                              ChatPage(

                                receiverId:
                                contact["uid"],

                                receiverName:
                                contact["userName"],
                              ),
                        ),
                      );
                    },

                    child: Padding(

                      padding: const EdgeInsets.all(12),

                      child: Row(

                        children: [

                          // Profile Image
                          CircleAvatar(

                            radius: 32,

                            backgroundColor:
                            Colors.green.shade100,

                            backgroundImage:
                            contact["image"] != null &&
                                contact["image"] != ""
                                ? NetworkImage(
                              contact["image"],
                            )
                                : null,

                            child:
                            contact["image"] == ""
                                ? const Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.green,
                            )
                                : null,
                          ),

                          const SizedBox(width: 15),

                          // Name + Number
                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(

                                  contact["userName"] ?? "",

                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(

                                  contact["phoneNumber"] ?? "",

                                  style: TextStyle(
                                    color:
                                    Colors.grey.shade700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Chat Button
                          Container(

                            decoration: BoxDecoration(

                              color: Colors.green.shade50,

                              borderRadius:
                              BorderRadius.circular(14),
                            ),

                            child: IconButton(

                              onPressed: () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (context) =>
                                        ChatPage(

                                          receiverId:
                                          contact["uid"],

                                          receiverName:
                                          contact["userName"],
                                        ),
                                  ),
                                );
                              },

                              icon: const Icon(
                                Icons.chat_bubble,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}