import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MaintenanceDialog extends StatelessWidget {
  const MaintenanceDialog({Key? key}) : super(key: key);

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
                Lottie.asset(
                  'assets/Lottie/maintenance.json',
                  height: size.height * 0.1,
                  width: size.height * 0.1,
                ),
                Center(
                  child: Text(
                    "Way 2 Sports",
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "App is Under Maintenance",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        SystemNavigator.pop();
                      },
                      child: Container(
                        height: 40,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                          child: Text(
                            'OK',
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
