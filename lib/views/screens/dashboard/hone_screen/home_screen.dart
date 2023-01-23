import 'package:flutter/material.dart';

import 'conversation_screen.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
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
          ],
        ),
      ),
    );
  }
}

class SingleChatWidget extends StatelessWidget {
  final String? chatMessage;
  final String? chatTitle;
  final Color? seenStatusColor;
  final String? imageUrl;

  const SingleChatWidget({
    Key? key,
    this.chatMessage,
    this.chatTitle,
    this.seenStatusColor,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ChatDetailPage();
        }));
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl!),
          ),
          Expanded(
            child: ListTile(
              title: Text('$chatTitle', style: const TextStyle(fontWeight: FontWeight.w600)),
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
