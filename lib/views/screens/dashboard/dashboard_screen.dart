import 'dart:async';
import 'dart:developer';

import 'package:chat_firebase/services/route_helper.dart';
import 'package:chat_firebase/views/screens/auth_screens/signup_screen.dart';
import 'package:chat_firebase/views/screens/dashboard/camera_screen/camera_screen.dart';
import 'package:chat_firebase/views/screens/dashboard/group_chat/select_user.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../../../controllers/firebase_controller.dart';
import '../../../services/enums/dialog_transition.dart';
import '../../../services/get_animated_dialog.dart';
import '../../base/dialogs/logout_dialog.dart';
import '../splash_screen/splash_screen.dart';
import 'call_tab.dart';
import 'group_chat/group_chat_screen.dart';
import 'home_screen/select_group_audience.dart';
import 'status/status_tab.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    super.initState();
    Timer.run(() async {
      tabController.addListener(() {
        setState(() {});
      });
      await Get.find<FirebaseController>().getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    log("${tabController.index}");
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "WhatsApp",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          actions: [
            // Widget for the search button
            // IconButton(
            //   icon: const Icon(Icons.search),
            //   color: Colors.white,
            //   onPressed: () {},
            // ),
            // Widget for implementing the three-dot menu
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
                      value: 'group',
                      child: Text('New Group'),
                    ),
                    // const PopupMenuItem(
                    //   value: 'broadcast',
                    //   child: Text('New Broadcast'),
                    // ),
                    // const PopupMenuItem(
                    //   value: 'devices',
                    //   child: Text('Linked Devices'),
                    // ),
                    // const PopupMenuItem(
                    //   value: 'starred_messages',
                    //   child: Text('Starred Messages'),
                    // ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Text('Settings'),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'settings') {
                    Navigator.push(context, getCustomRoute(child: const ProfileScreen()));
                  }
                  if (value == 'group') {
                    Navigator.push(context, getCustomRoute(child: const SelectGroupAudience()));
                  }
                  if (value == 'logout') {
                    ShowDialog().getAnimatedDialog(context: context, child: const LogoutDialog(), transitionType: DialogTransition.center).then((value) {
                      if (value ?? false) {
                        Get.find<FirebaseController>().firebaseAuth.signOut();
                        Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const SplashScreen()), (route) => false);
                      }
                    });
                  }
                },
              ),
            ),
          ],
          backgroundColor: const Color(0xff025c4c),
          bottom: TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                iconMargin: EdgeInsets.all(0),
                icon: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                ),
              ),
              Tab(
                child: Text(
                  'CHATS',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // Tab(
              //   child: Text(
              //     'GROUPS',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              Tab(
                child: Text(
                  'STATUS',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'CALLS',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            labelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            CameraScreen(),
            // ChatsTab(),
            GroupChatsTab(),
            StatusTab(),
            CallTab(),
          ],
        ),
        floatingActionButton: tabController.index == 1
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, getCustomRoute(child: const SelectUserScreen()));
                },
                child: const Icon(Icons.add))
            : null,
      ),
    );
  }
}
