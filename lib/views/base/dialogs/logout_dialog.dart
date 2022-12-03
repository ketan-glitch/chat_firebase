import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common_button.dart';
import '../custom_image.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      // title: true ? null : Padding(
      //     padding: const EdgeInsets.only(top:40.0),
      //     child: CustomAssetImage(path: Assets.imagesLogo,height: 60,)
      // ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Theme.of(context).primaryColor)),
            child: Center(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.red.withOpacity(0.8), BlendMode.srcATop),
                child: const CustomAssetImage(
                  path: Assets.imagesExclaim,
                  color: Colors.white,
                  height: 40,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Are you sure you want to logout!",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  type: ButtonType.secondary,
                  title: 'Cancel',
                  height: 40,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                CustomButton(
                  type: ButtonType.primary,
                  title: 'Logout',
                  height: 40,
                  onTap: () {
                    // Get.find<AuthController>().clearSharedData();

                    Navigator.pop(context);
                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
