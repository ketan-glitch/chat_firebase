import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../generated/assets.dart';
import '../../../services/extra_methods.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({Key? key, required this.skip, this.remark = ''}) : super(key: key);

  final bool skip;
  final String remark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      child: IntrinsicHeight(
        child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Image(
                  image: const AssetImage(Assets.imagesLogo),
                  height: size.height * 0.1,
                ),
                Center(
                  child: Text(
                    "Update App",
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  remark,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(fontSize: 12.0, fontWeight: FontWeight.w700, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (skip)
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              'Later',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (skip)
                      const SizedBox(
                        width: 10,
                      ),
                    InkWell(
                      onTap: () async {
                        if (GetPlatform.isAndroid) {
                          //TODO: CHANGE ANDROID LINK
                          ExtraMethods.launchInBrowser('https://play.google.com/store/apps/details?id=com.jaihobabag');
                        } else {
                          //TODO: CHANGE IOS LINK
                          ExtraMethods.launchInBrowser('https://apps.apple.com/us/app/way2sports/id1630920516');
                        }
                      },
                      child: Container(
                        height: 40,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                          child: Text(
                            'Update Now',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
