import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/service_controller.dart';

getImageBottomSheet(context) {
  return showModalBottomSheet(
    context: context,
    elevation: 0,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return const ShowImageOptions();
    },
  );
}

class ShowImageOptions extends StatelessWidget {
  const ShowImageOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: Container(
        width: double.infinity,
        height: 70.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  var navigator = Navigator.of(context);
                  File? data = await ServiceController().pickImage(ImageSource.gallery, context);
                  navigator.pop(data);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.image,
                      size: 25.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Gallery",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var navigator = Navigator.of(context);
                  File? data = await ServiceController().pickImage(ImageSource.camera, context);

                  navigator.pop(data);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 25.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Camera",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
