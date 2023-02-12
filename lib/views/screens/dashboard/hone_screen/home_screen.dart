import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/data/models/response/user_model.dart';
import 'package:chat_firebase/views/base/custom_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../../../../services/constants.dart';
import 'conversation_screen.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  int _limit = 20;
  int _limitIncrement = 20;
  String _textSearch = "";
  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent && !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            // stream: FirebaseFirestore.instance.collection('users').limit(100).snapshots(),
            stream: Get.find<FirebaseController>().getStreamFireStore(FireStoreConstants.pathUserCollection, _limit, _textSearch),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snapshot.data?.docs[index].data()! as Map<String, dynamic>;
                  UserModel userModel = UserModel.fromJson(data);
                  return SingleChatWidget(
                    // chatTitle: userModel.name ?? 'Unknown User',
                    // chatMessage: userModel.status ?? 'Available',
                    // seenStatusColor: Colors.blue,
                    // imageUrl: userModel.profilePhoto,
                    peer: userModel,
                  );
                },

                /*children: const [
                  SingleChatWidget(
                      chatTitle: "Arya Stark",
                      chatMessage: 'I wish GoT had better ending',
                      seenStatusColor: Colors.blue,
                      imageUrl:
                          'https://static-koimoi.akamaized.net/wp-content/new-galleries/2020/09/maisie-williams-aka-arya-stark-of-game-of-thrones-someone-told-me-in-season-three-that-i-was-going-to-kill-the-night-king001.jpg'),
                  SingleChatWidget(
                      chatTitle: "Robb Stark",
                      chatMessage: 'Did you check Maisie\'s latest post?',
                      seenStatusColor: Colors.grey,
                      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDXCC-UB67rk0HtbmrDvVsIGvnPfTAMc_tSg&usqp=CAU'),
                  SingleChatWidget(
                      chatTitle: "Jaqen H'ghar",
                      chatMessage: 'Valar Morghulis',
                      seenStatusColor: Colors.grey,
                      imageUrl: 'https://static3.srcdn.com/wordpress/wp-content/uploads/2017/06/Jaqen-Hghar-Game-of-Thrones.jpg'),
                  SingleChatWidget(
                      chatTitle: "Sansa Stark",
                      chatMessage: 'The North Remembers',
                      seenStatusColor: Colors.blue,
                      imageUrl: 'https://i.insider.com/5ce420e193a15232821d3084?width=700'),
                  SingleChatWidget(
                      chatTitle: "Jon Snow",
                      chatMessage: 'Stick em\' with the pointy end',
                      seenStatusColor: Colors.grey,
                      imageUrl: 'https://i.insider.com/5cb3c8e96afbee373d4f2b62?width=700'),
                  SingleChatWidget(
                      chatTitle: "Arya Stark",
                      chatMessage: 'I wish GoT had better ending',
                      seenStatusColor: Colors.blue,
                      imageUrl:
                          'https://static-koimoi.akamaized.net/wp-content/new-galleries/2020/09/maisie-williams-aka-arya-stark-of-game-of-thrones-someone-told-me-in-season-three-that-i-was-going-to-kill-the-night-king001.jpg'),
                  SingleChatWidget(
                      chatTitle: "Robb Stark",
                      chatMessage: 'Did you check Maisie\'s latest post?',
                      seenStatusColor: Colors.blue,
                      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDXCC-UB67rk0HtbmrDvVsIGvnPfTAMc_tSg&usqp=CAU'),
                  SingleChatWidget(
                      chatTitle: "Jon Snow",
                      chatMessage: 'Stick em\' with the pointy end',
                      seenStatusColor: Colors.blue,
                      imageUrl: 'https://i.insider.com/5cb3c8e96afbee373d4f2b62?width=700'),
                ],*/
              );
            }),
      ),
    );
  }
}

class SingleChatWidget extends StatelessWidget {
  final UserModel peer;

  const SingleChatWidget({Key? key, required this.peer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? chatMessage = peer.status ?? "Available";
    String? chatTitle = peer.name ?? "Unknown User";
    Color? seenStatusColor = Colors.blue;
    String? imageUrl = peer.profilePhoto;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage(peer: peer);
        }));
      },
      child: Row(
        children: [
          if (imageUrl != null)
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(imageUrl),
            )
          else
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(Assets.imagesUserPlaceholder),
            ),
          Expanded(
            child: ListTile(
              title: Text(
                '$chatTitle',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(children: [
                Icon(
                  seenStatusColor == Colors.blue ? Icons.done_all : Icons.done,
                  size: 15,
                  color: seenStatusColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      '$chatMessage',
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ]),
              trailing: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Yesterday',
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
