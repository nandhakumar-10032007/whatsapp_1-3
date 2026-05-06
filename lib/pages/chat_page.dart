import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  final String receiverId;
  final String receiverName;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController messageController =
  TextEditingController();

  final String currentUserId =
      FirebaseAuth.instance.currentUser!.uid;

  String getChatRoomId() {

    List<String> ids = [
      currentUserId,
      widget.receiverId,
    ];

    ids.sort();

    return ids.join("_");
  }

  Future<void> sendMessage() async {

    if (messageController.text.trim().isEmpty) {
      return;
    }

    String chatRoomId = getChatRoomId();

    Map<String, dynamic> messageData = {

      "senderId": currentUserId,

      "receiverId": widget.receiverId,

      "message": messageController.text.trim(),

      "timestamp": Timestamp.now(),

      "isSeen": false,
    };

    // Save Message
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .add(messageData);

    // Save Last Message
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatRoomId)
        .set({

      "users": [
        currentUserId,
        widget.receiverId,
      ],

      "lastMessage":
      messageController.text.trim(),

      "lastMessageTime":
      Timestamp.now(),

    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {

    String chatRoomId = getChatRoomId();

    return Scaffold(

      backgroundColor: const Color(0xffECE5DD),

      appBar: AppBar(

        elevation: 1,
        backgroundColor: const Color(0xff075E54),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        titleSpacing: 0,

        title: Row(

          children: [

            const CircleAvatar(

              radius: 22,

              backgroundColor: Colors.white,

              child: Icon(
                Icons.person,
                color: Color(0xff075E54),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    widget.receiverName,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    "Online",

                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        actions: [

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),

          PopupMenuButton(

            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),

            itemBuilder: (context) {

              return [

                const PopupMenuItem(
                  child: Text("View Contact"),
                ),

                const PopupMenuItem(
                  child: Text("Search"),
                ),

                const PopupMenuItem(
                  child: Text("Wallpaper"),
                ),
              ];
            },
          ),
        ],
      ),

      body: Column(

        children: [

          // Messages
          Expanded(

            child: StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(chatRoomId)
                  .collection("messages")
                  .orderBy(
                "timestamp",
                descending: false,
              )
                  .snapshots(),

              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {

                  return Center(

                    child: Column(

                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: [

                        Icon(
                          Icons.chat_bubble_outline,
                          size: 90,
                          color: Colors.grey.shade400,
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "Start Conversation",

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Send your first message",

                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var messages =
                    snapshot.data!.docs;

                return ListView.builder(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),

                  itemCount: messages.length,

                  itemBuilder: (context, index) {

                    var data =
                    messages[index].data()
                    as Map<String, dynamic>;

                    bool isMe =
                        data["senderId"] ==
                            currentUserId;

                    return Align(

                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                      child: Container(

                        constraints:
                        BoxConstraints(
                          maxWidth:
                          MediaQuery.of(context)
                              .size
                              .width *
                              0.75,
                        ),

                        margin:
                        const EdgeInsets.symmetric(
                          vertical: 5,
                        ),

                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(

                          color: isMe
                              ? const Color(0xffDCF8C6)
                              : Colors.white,

                          borderRadius:
                          BorderRadius.only(

                            topLeft:
                            const Radius.circular(18),

                            topRight:
                            const Radius.circular(18),

                            bottomLeft:
                            Radius.circular(
                              isMe ? 18 : 0,
                            ),

                            bottomRight:
                            Radius.circular(
                              isMe ? 0 : 18,
                            ),
                          ),

                          boxShadow: [

                            BoxShadow(
                              color:
                              Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.end,

                          children: [

                            Text(

                              data["message"],

                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade900,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Row(

                              mainAxisSize:
                              MainAxisSize.min,

                              children: [

                                Text(

                                  "Now",

                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                    Colors.grey.shade600,
                                  ),
                                ),

                                const SizedBox(width: 4),

                                if (isMe)
                                  const Icon(
                                    Icons.done_all,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                              ],
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

          // Bottom Message Box
          Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),

            decoration: const BoxDecoration(
              color: Colors.white,
            ),

            child: SafeArea(

              child: Row(

                children: [

                  // TextField
                  Expanded(

                    child: Container(

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),

                      decoration: BoxDecoration(

                        color: Colors.grey.shade100,

                        borderRadius:
                        BorderRadius.circular(30),
                      ),

                      child: Row(

                        children: [

                          Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey.shade600,
                          ),

                          const SizedBox(width: 10),

                          Expanded(

                            child: TextField(

                              controller:
                              messageController,

                              decoration:
                              const InputDecoration(

                                hintText:
                                "Type a message",

                                border:
                                InputBorder.none,
                              ),
                            ),
                          ),

                          Icon(
                            Icons.attach_file,
                            color: Colors.grey.shade600,
                          ),

                          const SizedBox(width: 10),

                          Icon(
                            Icons.camera_alt,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Send Button
                  CircleAvatar(

                    radius: 28,

                    backgroundColor:
                    const Color(0xff075E54),

                    child: IconButton(

                      onPressed: sendMessage,

                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}