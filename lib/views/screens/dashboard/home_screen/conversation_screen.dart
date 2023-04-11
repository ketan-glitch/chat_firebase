import 'dart:async';
import 'dart:developer';
import 'dart:io';

// import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/services/enums/dialog_transition.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/services/get_animated_dialog.dart';
import 'package:chat_firebase/views/screens/auth_screens/login_screen.dart';
import 'package:chat_firebase/views/screens/dashboard/home_screen/update_group_details_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../controllers/chat_controller.dart';
import '../../../../controllers/service_controller.dart';
import '../../../../data/models/response/message_chat.dart';
import '../../../../data/models/response/user_model.dart';
import '../../../../services/constants.dart';
import '../../../base/custom_bubble/bubble_special_one.dart';
import '../../../base/custom_image.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.peers, this.groupName, this.groupImage});
  // final UserModel peer;
  final List<UserModel> peers;
  final String? groupName;
  final String? groupImage;
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // final FocusNode focusNode = FocusNode();
  bool expanded = false;

  toggle() {
    expanded = !expanded;
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  void readLocal() {
    // var auth = Get.find<AuthController>();
    var firebase = Get.find<FirebaseController>();
    var chat = Get.find<ChatController>();
    if (firebase.userData.number.isValid) {
      chat.currentUserId = firebase.userData.number!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
    if (widget.peers.length > 1) {
      // chat.groupChatId =
    } else {
      String peerId = widget.peers.first.number!;
      if (chat.currentUserId.compareTo(peerId) > 0) {
        chat.groupChatId = '${chat.currentUserId}-$peerId';
      } else {
        chat.groupChatId = '$peerId-${chat.currentUserId}';
      }
      log(chat.groupChatId, name: "groupChatId");
    }

    // firebase.updateDataFirestore(
    //   FireStoreConstants.pathUserCollection,
    //   firebase.userData.number!,
    //   {FireStoreConstants.chattingWith: peerId},
    // );
  }

  @override
  void initState() {
    super.initState();
    var chat = Get.find<ChatController>();
    chat.listScrollController.addListener(chat.scrollListener);
    readLocal();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (chat.listScrollController.hasClients) {
        chat.listScrollController
            .animateTo(chat.listScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String chatName = '';
    String? chatImage;
    if (widget.peers.length > 1) {
      chatName = widget.groupName ?? '';
      chatImage = widget.groupImage ?? '';
    } else {
      chatName = widget.peers.first.name.getIfValid;
      chatImage = widget.peers.first.profilePhoto.getIfValid;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff025c4c),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Builder(builder: (context) {
              /*if (widget.peers.length > 1) {
                return Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      chatName.getIfValid.inCaps.initials,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                //   var images = <String>[];
                //   for (var element in peers) {
                //     if (element.profilePhoto.isValid) {
                //       images.add(element.profilePhoto!);
                //     }
                //   }
                //   return GroupProfilePictureWidget(
                //     images: images,
                //   );

                // return GroupProfilePictureWidget(
                //   images: widget.peers.map((e) => e.profilePhoto.toString()).toList(),
                // );
              } else */
              if (chatImage.isValid) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: CustomImage(
                    path: chatImage!,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                return const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(Assets.imagesUserPlaceholder),
                );
              }
            }),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chatName.capitalizeFirstOfEach,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 6 + 13,
                  ),
                  // const Text(
                  //   "Online",
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 13,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (widget.peers.length > 1)
            Theme(
              data: Theme.of(context).copyWith(useMaterial3: false),
              child: PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                // elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'update',
                      child: Text('Update Group Details'),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'update') {
                    ShowDialog()
                        .getAnimatedDialog(context: context, child: const UpdateGroupDetailsDialog(), transitionType: DialogTransition.center)
                        .then((value) {});
                  }
                },
              ),
            ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            color: const Color(0xFFece7e1),
            child: const CustomAssetImage(
              path: Assets.imagesBgChat,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: GetBuilder<ChatController>(
                  builder: (chatController) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: chatController.getChatStream(chatController.groupChatId, chatController.limit),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          log("${snapshot.data?.docs}", name: "LENGTH");
                          if (snapshot.hasData) {
                            chatController.listMessage = snapshot.data!.docs;
                            if (chatController.listMessage.isNotEmpty) {
                              return ListView.builder(
                                controller: chatController.listScrollController,
                                itemCount: snapshot.data?.docs.length,
                                padding: const EdgeInsets.only(top: 10, bottom: 70),
                                // physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  log('${snapshot.data!.docs[index].reference}');
                                  MessageChat messageChat = MessageChat.fromDocument(snapshot.data!.docs[index]);

                                  bool isSender = messageChat.idFrom == chatController.currentUserId;
                                  return ChatWidgetWithShadow(
                                    messageChat: messageChat,
                                    isSender: isSender,
                                    reference: snapshot.data!.docs[index].reference,
                                  );
                                },
                              );
                            } else {
                              return const Center(child: Text("No message here yet..."));
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          }
                        });
                  },
                ),
              ),
              GetBuilder<ChatController>(
                builder: (chatController) {
                  return Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      // height: 70,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xff025c4c),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              onPressed: toggle,
                              isSelected: expanded,
                              selectedIcon: const Icon(Icons.attach_file),
                              icon: const Icon(Icons.attachment),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              controller: chatController.textEditingController,
                              maxLines: 6,
                              minLines: 1,
                              decoration: const InputDecoration(
                                hintText: "Write message...",
                                filled: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(45)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(45)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(45)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              chatController.onSendMessage(content: chatController.textEditingController.text, type: TypeMessage.text, peer: widget.peers);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff025c4c),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (expanded) ShowBottomSheet(peer: widget.peers),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatWidgetWithShadow extends StatefulWidget {
  const ChatWidgetWithShadow({Key? key, required this.messageChat, required this.isSender, required this.reference}) : super(key: key);
  final MessageChat messageChat;
  final bool isSender;
  final DocumentReference reference;

  @override
  State<ChatWidgetWithShadow> createState() => _ChatWidgetWithShadowState();
}

class _ChatWidgetWithShadowState extends State<ChatWidgetWithShadow> {
  UserModel? sender;
  getUser() {
    Timer.run(() async {
      try {
        // log("${widget.messageChat.from}", name: "reference");
        if (widget.messageChat.from != null) {
          var reference = FirebaseFirestore.instance.collection(FireStoreConstants.pathUserCollection).doc(widget.messageChat.from);
          reference.withConverter<UserModel>(
              fromFirestore: (snapshot, _) => UserModel.fromJsonn(snapshot.data()!), toFirestore: (snapshot, _) => snapshot.toJsonn());
          // log("${(await reference.get()).data()}", name: "reference");
          sender = UserModel.fromJson((await reference.get()).data() as Map<String, dynamic>);
          if (mounted) setState(() {});
          // reference.snapshots().listen((event) {
          //   log("$event");
          // });
        }
      } catch (e) {
        log("$e", name: "ERROR");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.messageChat.type == TypeMessage.file) checkFileExists();
    getUser();
  }

  double downloadProgress = 0;

  bool downloading = false;
  bool downloaded = false;

  CancelToken cancelToken = CancelToken();
  Future<File> download() async {
    String path = widget.messageChat.content;
    Response response;
    var dio = Dio();
    var directory = await getApplicationDocumentsDirectory();
    File file = File(
      '/storage/emulated/0/Download/${path.split('?alt').first.fileName}',
    );
    log(file.path);
    response = await dio.download(
      (path.contains('http') ? '' : AppConstants.baseUrl) + path,
      file.path,
      cancelToken: cancelToken,
      deleteOnError: true,
      onReceiveProgress: (int a, int b) {
        downloadProgress = ((a / b) * 100);
        setState(() {});
      },
    ).onError((DioError error, stackTrace) {
      log("${error.message}");
      return Response(requestOptions: RequestOptions(path: path));
    });
    /*snackBarKey.currentState!.showSnackBar(
      SnackBar(
        content: const Text("Open file ?"),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: "Open",
          onPressed: () {},
        ),
      ),
    );*/
    // if (false) Share.shareFiles([file.path]);
    return file;
  }

  checkFileExists() {
    Timer.run(() async {
      File file = File(
        '/storage/emulated/0/Download/${widget.messageChat.content.split('?alt').first.fileName}',
      );
      if (await file.exists()) {
        downloaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () {
        if (widget.isSender) {
          HapticFeedback.heavyImpact();

          ShowDialog().getAnimatedDialog(
              context: context,
              child: Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('Delete'),
                      onTap: () async {
                        Get.find<ChatController>().deleteMessage(widget.reference).then((value) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              ),
              transitionType: DialogTransition.center);
        }
      },
      child: GetShadowWidget(
        isSender: widget.isSender,
        child: BubbleSpecialOne(
          isSender: widget.isSender,
          color: widget.isSender ? const Color(0xFFdcf8c7) : Colors.white,
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            // color: Colors.white,
          ),
          padding: const EdgeInsets.only(left: 8, right: 14, top: 3, bottom: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sender != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    sender!.name.getIfValid,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.0,
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (widget.messageChat.type == TypeMessage.image)
                CustomImage(
                  path: widget.messageChat.content,
                  fit: BoxFit.cover,
                  height: size.height * .2,
                  width: size.width,
                ),
              if (widget.messageChat.type == TypeMessage.file)
                GestureDetector(
                  onTap: () async {
                    if (downloaded) {
                      await OpenFile.open('/storage/emulated/0/Download/${widget.messageChat.content.split('?alt').first.fileName}');
                    } else if (downloading) {
                      cancelToken.cancel('User Canceled Download');
                      downloading = false;
                      setState(() {});
                    } else {
                      downloading = true;
                      setState(() {});
                      await download();
                      await checkFileExists();
                      downloading = false;
                      if (mounted) setState(() {});
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    // height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Stack(
                              children: [
                                const Center(
                                  child: CustomAssetImage(
                                    path: Assets.imagesFile,
                                    width: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      widget.messageChat.content.extension,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.messageChat.content.split('?alt').first.fileName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          if (!downloaded)
                            MaterialButton(
                              minWidth: 50,
                              elevation: 0,
                              shape: const CircleBorder(),
                              color: Colors.grey.shade200,
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                if (downloaded) {
                                  await OpenFile.open('/storage/emulated/0/Download/${widget.messageChat.content.split('?alt').first.fileName}');
                                } else if (downloading) {
                                  cancelToken.cancel('User Canceled Download');
                                  downloading = false;
                                  setState(() {});
                                } else {
                                  downloading = true;
                                  setState(() {});
                                  await download();
                                  await checkFileExists();
                                  downloading = false;
                                  if (mounted) setState(() {});
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Builder(builder: (context) {
                                  /*if (downloaded) {
              return Icon(
                  Icons.open_in_new_rounded,
                  color: Colors.grey.shade700,
              );
            } else */
                                  if (downloading) {
                                    return Stack(
                                      children: [
                                        Center(
                                          child: CircularProgressIndicator(
                                            value: downloadProgress,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Icon(
                                      Icons.download,
                                      color: Colors.grey.shade700,
                                    );
                                  }
                                }),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (widget.messageChat.type == TypeMessage.image || widget.messageChat.type == TypeMessage.file) const SizedBox(height: 10),
              if (widget.messageChat.type == TypeMessage.text)
                Text(
                  widget.messageChat.content,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.0,
                  ),
                ),
              if (widget.messageChat.type == TypeMessage.image || widget.messageChat.type == TypeMessage.file) const SizedBox(height: 5),
              IntrinsicWidth(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateTime.fromMillisecondsSinceEpoch(int.parse(widget.messageChat.timestamp)).dddMMTime,
                    style: GoogleFonts.montserrat(fontSize: 11.0, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GetShadowWidget extends StatelessWidget {
  const GetShadowWidget({Key? key, required this.child, required this.isSender}) : super(key: key);

  final Widget child;
  final bool isSender;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 2,
          right: isSender ? 2 : null,
          left: isSender ? null : 2,
          child: ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade400],
                ).createShader(bounds);
              },
              child: child),
        ),
        child,
      ],
    );
  }
}

class ShowBottomSheet extends StatelessWidget {
  const ShowBottomSheet({Key? key, required this.peer}) : super(key: key);
  final List<UserModel> peer;

  sendMessageWithAttachment(String fileType, File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    log('$sizeInBytes : $sizeInMb', name: "FILE SIZE");
    if (sizeInMb > 1.8) {
      Fluttertoast.showToast(msg: "File size exceeds 2mb");
    } else {
      // Get.find<ChatController>().onSendMessage(content: Get.find<ChatController>().textEditingController.text, type: TypeMessage.text, peerId: chatId);
      Get.find<FirebaseController>().uploadFile(fileType == 'image' ? ImageUploadType.message : ImageUploadType.messageFile, peer: peer, file: file);
      // Get.find<ChatController>().sendMessageToDietitian(chatId, fileType: fileType);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
        child: IntrinsicHeight(
          child: Container(
            height: size.height * .27,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    children: [
                      ChatAttachmentItem(
                        title: 'Camera',
                        icon: Icons.camera,
                        color: Theme.of(context).primaryColor,
                        onTap: () async {
                          File? data = await ServiceController().pickImage(ImageSource.camera, context, imageQuality: 30);
                          if (data != null) {
                            sendMessageWithAttachment('image', data);
                          }
                        },
                      ),
                      ChatAttachmentItem(
                        title: 'Gallery',
                        icon: Icons.photo,
                        color: Colors.blue,
                        onTap: () async {
                          File? data = await ServiceController().pickImage(ImageSource.gallery, context, imageQuality: 70);
                          if (data != null) {
                            sendMessageWithAttachment('image', data);
                          }
                        },
                      ),
                      ChatAttachmentItem(
                        title: 'File',
                        icon: Icons.file_upload,
                        color: Colors.purple,
                        onTap: () async {
                          File? data = await ServiceController().pickFile(context);
                          if (data != null) {
                            sendMessageWithAttachment('file', data);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatAttachmentItem extends StatelessWidget {
  const ChatAttachmentItem({Key? key, required this.title, required this.icon, required this.color, required this.onTap}) : super(key: key);

  final String title;
  final IconData icon;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: SizedBox(
        width: size.width * .2,
        height: size.width * .2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color,
                      color.lighten(.3),
                    ],
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.openSans(color: Colors.black, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupProfilePictureWidget extends StatelessWidget {
  const GroupProfilePictureWidget({Key? key, required this.images}) : super(key: key);

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: Builder(builder: (context) {
        if (images.isEmpty) {
          return const CustomAssetImage(height: 50, width: 50, path: Assets.imagesUserPlaceholder);
        }
        if (images.length == 2) {
          var top = [images.first, images[1]];
          var bottom = [Get.find<FirebaseController>().userData.profilePhoto!];
          return SizedBox(
            height: 50,
            width: 50,
            child: Column(
              children: [
                Row(
                  children: [
                    ...top.map((e) => Expanded(child: CustomImage(path: e, fit: BoxFit.cover, height: 25))).toList(),
                  ],
                ),
                Row(
                  children: [
                    ...bottom.map((e) => Expanded(child: CustomImage(path: e, fit: BoxFit.cover, height: 25))).toList(),
                  ],
                ),
              ],
            ),
          );
        } else {
          var top = [images.first];
          if (images.length > 1) {
            top.add(images[1]);
          }
          var bottom = [Get.find<FirebaseController>().userData.profilePhoto];
          return SizedBox(
            height: 50,
            width: 50,
            child: Column(
              children: [
                Row(
                  children: [
                    ...top.map((e) => Expanded(child: CustomImage(path: e, fit: BoxFit.cover, height: 25))).toList(),
                  ],
                ),
                Row(
                  children: [
                    ...bottom.map((e) => Expanded(child: CustomImage(path: e.toString(), fit: BoxFit.cover, height: 25))).toList(),
                    if (images.length > 3) Text('+ ${images.length - 3}'),
                  ],
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
