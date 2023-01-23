import 'package:flutter/material.dart';

class CallTab extends StatelessWidget {
  const CallTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            SingleCallWidget(
              callStatus: 'Outgoing',
              callType: 'Audio',
              chatMessage: 'Today, 12:28 PM',
              chatTitle: 'Arya Stark',
              imageUrl:
                  'https://static-koimoi.akamaized.net/wp-content/new-galleries/2020/09/maisie-williams-aka-arya-stark-of-game-of-thrones-someone-told-me-in-season-three-that-i-was-going-to-kill-the-night-king001.jpg',
            ),
            SingleCallWidget(
              callStatus: 'Incoming',
              callType: 'Video',
              chatMessage: 'Today, 01:11 AM',
              chatTitle: 'Cersei Lannister',
              imageUrl: 'https://pyxis.nymag.com/v1/imgs/8a2/6a6/8ddcaf4454e34b72484c5393560af17366-09-cersei-lannister.rsquare.w700.jpg',
            ),
            SingleCallWidget(
              callStatus: 'Incoming',
              callType: 'Video',
              chatMessage: 'Today, 5:28 AM',
              chatTitle: 'Red Woman',
              imageUrl: 'https://upload.wikimedia.org/wikipedia/en/8/80/Melisandre-Carice_van_Houten.jpg',
            ),
            SingleCallWidget(
              callStatus: 'Outgoing',
              callType: 'Audio',
              chatMessage: 'Today, 12:28 PM',
              chatTitle: 'The Mountain',
              imageUrl: 'lib/assets/images/Mountains.jpg',
            ),
          ],
        ),
      ),
    );
  }
}

class SingleCallWidget extends StatelessWidget {
  final String? chatMessage;
  final String? chatTitle;
  final String? callStatus;
  final String? imageUrl;
  final String? callType;

  const SingleCallWidget({
    Key? key,
    this.chatMessage,
    this.chatTitle,
    this.callStatus,
    this.imageUrl,
    this.callType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  callStatus == 'Incoming' ? (Icons.call_received_sharp) : Icons.call_made_sharp,
                  size: 15,
                  color: callStatus == 'Incoming' ? Colors.teal : Colors.red,
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Icon(callType == 'Audio' ? Icons.call : Icons.videocam, color: Colors.teal),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
