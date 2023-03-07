import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:chat_firebase/data/models/response/status_model.dart';
import 'package:chat_firebase/data/models/response/user_model.dart';
import 'package:chat_firebase/services/date_formatters_and_converters.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/views/base/custom_image.dart';
import 'package:chat_firebase/views/base/image_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../../controllers/firebase_controller.dart';
import '../../../../services/constants.dart';
import '../../../../services/route_helper.dart';
import 'status_view/status_view.dart';

class StatusTab extends StatefulWidget {
  const StatusTab({Key? key}) : super(key: key);

  @override
  State<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  @override
  void initState() {
    super.initState();
    Get.find<FirebaseController>().getStatusesTest();
    // Get.find<FirebaseController>().getStatuses().listen((event) {
    //   for (var element in event.docs) {
    //     log("${element.data() as Map<String, dynamic>}");
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseController>(
      builder: (firebaseController) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AddStatusTile(),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text('Viewed updates', style: TextStyle(fontWeight: FontWeight.w400)),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var status = firebaseController.statuses[index];
                        return SingleStatusItem(
                          status: status,
                        );
                      },
                      childCount: firebaseController.statuses.length,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 100,
              right: 20,
              child: FloatingActionButton.small(
                heroTag: '1',
                backgroundColor: const Color(0xff025c4c),
                onPressed: () {
                  Navigator.push(context, getCustomRoute(child: const UploadTextStatus()));
                },
                child: const Icon(Icons.edit),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: const Color(0xff025c4c),
                onPressed: () async {
                  var file = await getImageBottomSheet(context);
                  if (file != null) {
                    await firebaseController.uploadFile(ImageUploadType.status, file: file);
                  }
                },
                child: const Icon(Icons.image),
              ),
            )
          ],
        );
      },
    );
  }
}

class SingleStatusItem extends StatelessWidget {
  final Map<String, dynamic> status;
  const SingleStatusItem({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = (status['user'] as UserModel);
    var statuses = (status['statuses'] as List<StatusModel>);
    String? statusTitle = user.name;
    String? statusTime = statuses.last.createdAt!.timeAgo();
    String? statusImage = user.profilePhoto;
    return Material(
      elevation: 0,
      child: InkWell(
        onTap: () async {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return StatusViewWidget(statuses: statuses);
            },
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          color: Colors.transparent,
          child: Row(
            children: [
              StatusView(
                radius: 30,
                spacing: 15,
                strokeWidth: 2,
                indexOfSeenStatus: 0,
                numberOfStatus: statuses.length,
                padding: 4,
                seenColor: Colors.grey,
                unSeenColor: const Color(0xff025c4c),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(45)),
                  child: Builder(builder: (context) {
                    if (statusImage.isValid) {
                      return CustomImage(
                        path: statusImage!,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      );
                    }
                    return const CustomAssetImage(
                      path: Assets.imagesUserPlaceholder,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    );
                  }),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('$statusTitle'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text("$statusTime"),
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

class AddStatusTile extends StatelessWidget {
  const AddStatusTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseController>(builder: (firebaseController) {
      return Material(
        elevation: 0,
        child: InkWell(
          onTap: () async {
            var file = await getImageBottomSheet(context);
            await firebaseController.uploadFile(ImageUploadType.status, file: file);
          },
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            color: Colors.transparent,
            child: Row(
              children: [
                const SizedBox(width: 4),
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xff128C7E),
                      foregroundColor: const Color(0xff128C7E),
                      radius: 30,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(45)),
                        child: Builder(builder: (context) {
                          if (firebaseController.userData.profilePhoto.isValid) {
                            return CustomImage(
                              path: firebaseController.userData.profilePhoto!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            );
                          }
                          return const CustomAssetImage(
                            path: Assets.imagesUserPlaceholder,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          );
                        }),
                      ),
                    ),
                    const Positioned(
                      top: 40,
                      left: 40,
                      child: CircleAvatar(
                        radius: 10,
                        child: Icon(Icons.add, size: 20),
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: ListTile(
                    title: Text('Add Status'),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text('Tap to add status update'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class StatusViewWidget extends StatefulWidget {
  const StatusViewWidget({Key? key, required this.statuses}) : super(key: key);
  final List<StatusModel> statuses;

  @override
  State<StatusViewWidget> createState() => _StatusViewWidgetState();
}

class _StatusViewWidgetState extends State<StatusViewWidget> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  List<StoryItem> stories = [];

  @override
  void initState() {
    super.initState();
    for (var element in widget.statuses) {
      stories.add(
        StoryItem.pageImage(
          url: element.image!,
          // caption: "Still sampling",
          controller: storyController,
          imageFit: BoxFit.contain,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log("${stories.length}");
    return SizedBox(
      height: size.height - 45,
      child: Stack(
        children: [
          StoryView(
            storyItems: [...stories],
            onStoryShow: (s) {
              print("${s.shown} Showing a story");
            },
            onComplete: () {
              if (mounted && Navigator.canPop(this.context)) {
                Navigator.pop(this.context);
              }
            },
            progressPosition: ProgressPosition.top,
            repeat: false,
            controller: storyController,
          ),
          const Positioned(
            top: 20,
            left: 10,
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class UploadTextStatus extends StatefulWidget {
  const UploadTextStatus({Key? key}) : super(key: key);

  @override
  State<UploadTextStatus> createState() => _UploadTextStatusState();
}

class _UploadTextStatusState extends State<UploadTextStatus> {
  List<Color> colors = [
    const Color(0XFFff8768),
    const Color(0XFF18b6df),
    const Color(0XFF4dc2ff),
    const Color(0XFF766869),
    const Color(0XFF7d8fa4),
    const Color(0XFF4f96ff),
    const Color(0XFF733180),
    const Color(0XFF73c1a4),
    const Color(0XFF223541),
    const Color(0XFF8096cc),
    const Color(0XFFb03c72),
    const Color(0XFF90a03c),
    const Color(0XFFc49d39),
    const Color(0XFF802b37),
    const Color(0XFFb18a73),
    const Color(0XFFf7b229),
    const Color(0XFFb8ac21),
    const Color(0XFFc9a5cd),
    const Color(0XFF8d6f91),
    const Color(0XFFff968c),
    const Color(0XFF4bb261),
  ];
  List<String> fonts = [
    'Bryndan-Write',
    'Calistoga-Regular',
    'CourierPrime-Bold',
    'Damion-Regular',
    'Exo2-ExtraBold',
    'MorningBreeze-Regular.ttf',
    'Norican-Regular',
    'Optimistic_Text_A_Bd',
    'Optimistic_Text_A_Md',
    'Oswald-Heavy',
    'Roboto-Medium',
    'RobotoMono-Regular',
  ];

  int colorIndex = 0;
  int fontIndex = 0;
  TextEditingController _textEditingController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                color: colors[colorIndex % colors.length],
              ),
              child: SafeArea(
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Center(
                    child: AutoSizeTextField(
                      textAlign: TextAlign.center,
                      controller: _textEditingController,
                      minFontSize: 14.0,
                      maxFontSize: 35.0,
                      style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.white,
                        fontFamily: fonts[fontIndex % fonts.length],
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type a Status",
                        hintStyle: TextStyle(
                          fontSize: 35.0,
                          color: Colors.white38,
                          fontFamily: fonts[fontIndex % fonts.length],
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                    /*child: TextField(
                      textAlign: TextAlign.center,
                      minLines: 1,
                      maxLines: 30,
                      autofocus: true,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontFamily: fonts[fontIndex % fonts.length],
                      ),
                      decoration: InputDecoration(
                        hintText: "Type a Status",
                        hintStyle: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontFamily: fonts[fontIndex % fonts.length],
                        ),
                        border: InputBorder.none,
                      ),
                    ),*/
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.emoji_emotions_rounded,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    fontIndex++;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.font_download,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    colorIndex++;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.color_lens,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (_textEditingController.text.isValid)
            Positioned(
              bottom: 0,
              width: size.width,
              child: Container(
                color: Colors.black38,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        screenshotController.capture().then((Uint8List? image) async {
                          //
                          //Capture Done
                          if (image != null) {
                            final directory = await getApplicationDocumentsDirectory();
                            final imagePath = await File('${directory.path}/status-${getDateTime().millisecondsSinceEpoch}.png').create();
                            await imagePath.writeAsBytes(image);
                            Navigator.pop(context);
                            Get.find<FirebaseController>().avatarImageFile = imagePath;
                            Get.find<FirebaseController>().uploadFile(ImageUploadType.status);
                          }
                        }).catchError((onError) {
                          print(onError);
                        });
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
