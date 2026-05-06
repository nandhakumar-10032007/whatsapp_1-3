import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';
import 'add_contact.dart';
import 'contact_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final String currentUserId =
      FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(

        elevation: 0,
        backgroundColor: Colors.white,

        title: const Text(

          "WhatsApp",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.black,
          ),
        ),

        actions: [

          // Add Contact Button
          Container(

            margin: const EdgeInsets.only(right: 8),

            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),

            child: IconButton(

              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const AddContactPage(),
                  ),
                );
              },

              icon: const Icon(
                Icons.person_add,
                color: Colors.green,
              ),
            ),
          ),

          // Menu
          PopupMenuButton<String>(

            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),

            onSelected: (value) async {

              // Contacts
              if (value == "contacts") {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ContactPage(),
                  ),
                );
              }

              // Settings
              else if (value == "settings") {

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Settings Page Coming Soon",
                    ),
                  ),
                );
              }

              // Profile
              else if (value == "profile") {

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Profile Page Coming Soon",
                    ),
                  ),
                );
              }

              // Logout
              else if (value == "logout") {

                await FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const LoginPage(),
                  ),
                      (route) => false,
                );
              }
            },

            itemBuilder: (context) {

              return [

                const PopupMenuItem(
                  value: "profile",
                  child: Text("Profile"),
                ),

                const PopupMenuItem(
                  value: "contacts",
                  child: Text("Contacts"),
                ),

                const PopupMenuItem(
                  value: "settings",
                  child: Text("Settings"),
                ),

                const PopupMenuItem(
                  value: "logout",
                  child: Text("Logout"),
                ),

              ];
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("chats")
            .where(
          "users",
          arrayContains: currentUserId,
        )
        
            .snapshots(),

        builder: (context, snapshot) {

          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(

              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }

          // No Chats
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return Center(

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Container(

                    padding: const EdgeInsets.all(25),

                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 80,
                      color: Colors.green.shade400,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "No Chats Yet",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Start chatting with your friends",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(

                    height: 55,

                    child: ElevatedButton.icon(

                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.green,

                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),

                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const ContactPage(),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.message,
                        color: Colors.white,
                      ),

                      label: const Text(

                        "Start Chat",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Chat List
          var chats = snapshot.data!.docs;

          return ListView.builder(

            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),

            itemCount: chats.length,

            itemBuilder: (context, index) {

              var chat =
              chats[index].data()
              as Map<String, dynamic>;

              List users = chat["users"];

              String receiverId =
              users.firstWhere(
                    (id) => id != currentUserId,
              );

              return FutureBuilder<DocumentSnapshot>(

                future: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(receiverId)
                    .get(),

                builder: (context, userSnapshot) {

                  if (!userSnapshot.hasData ||
                      userSnapshot.data!.data() == null) {

                    return const SizedBox();
                  }

                  var userData =
                  userSnapshot.data!.data()
                  as Map<String, dynamic>;

                  return Container(

                    margin:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(18),

                      boxShadow: [

                        BoxShadow(
                          color:
                          Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: ListTile(

                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),

                      leading: CircleAvatar(

                        radius: 28,

                        backgroundColor:
                        Colors.green.shade100,

                        backgroundImage:
                        userData["image"] != null &&
                            userData["image"]
                                .toString()
                                .isNotEmpty

                            ? NetworkImage(
                          userData["image"],
                        )

                            : null,

                        child:
                        userData["image"] == null ||
                            userData["image"]
                                .toString()
                                .isEmpty

                            ? Text(

                          userData["userName"][0]
                              .toUpperCase(),

                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.green,
                          ),
                        )

                            : null,
                      ),

                      title: Text(

                        userData["userName"],

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),

                      subtitle: Padding(

                        padding:
                        const EdgeInsets.only(top: 4),

                        child: Text(

                          chat["lastMessage"] ?? "",

                          maxLines: 1,

                          overflow:
                          TextOverflow.ellipsis,

                          style: TextStyle(
                            color:
                            Colors.grey.shade700,
                          ),
                        ),
                      ),

                      trailing: Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          Text(

                            "Now",

                            style: TextStyle(
                              color:
                              Colors.green.shade700,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Icon(
                            Icons.done_all,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (context) =>
                                ChatPage(

                                  receiverId:
                                  receiverId,

                                  receiverName:
                                  userData["userName"],
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}