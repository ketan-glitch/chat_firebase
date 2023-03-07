import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../../../../controllers/firebase_controller.dart';
import '../../../../data/models/response/user_model.dart';
import '../../../../services/constants.dart';
import '../home_screen/home_screen.dart';

class SelectUserScreen extends StatelessWidget {
  const SelectUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select User",
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xff025c4c),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: Get.find<FirebaseController>().getStreamFireStore(FireStoreConstants.pathUserCollection, 100),
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
                    peer: userModel,
                  );
                },
              );
            }),
      ),
    );
  }
}
