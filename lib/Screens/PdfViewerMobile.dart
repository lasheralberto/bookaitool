import 'dart:typed_data';
import 'package:bookaitool/constants.dart';
import 'package:bookaitool/custoAppBar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:js' as js;

class PdfScreenSyncFussionMobile extends StatefulWidget {
  Uint8List pdfbytes;
  void Function(bool) onDeactivateProcessPdfMessage;

  PdfScreenSyncFussionMobile(
      {Key? key,
      required this.pdfbytes,
      required this.onDeactivateProcessPdfMessage})
      : super(key: key);

  @override
  State<PdfScreenSyncFussionMobile> createState() => _PdfScreenSyncFussionMobileState();
}

class _PdfScreenSyncFussionMobileState extends State<PdfScreenSyncFussionMobile> {
  bool backButtonPressed = false;

  void savePdfLocally(pdfContent) {
    const fileName = 'example.pdf'; // Specify the desired file name

    // Call the JavaScript function
    js.context.callMethod('saveFile', [fileName, pdfContent]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () async {
            savePdfLocally(widget.pdfbytes);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.colorButtons, // Background color
            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: StyleConstants.border, // Rounded corners
            ),
            padding: const EdgeInsets.all(16.0), // Button padding
          ),
          child: const Icon(
            Icons.downloading_rounded,
            size: 24.0, // Icon size
          ),
        ),
        backgroundColor: ColorConstants.colortheme,
        appBar: CustomAppBar(
          title: ' ',
          hasTitle: true,
        ),
        body: WillPopScope(
            onWillPop: () {
              // Handle the back button press here
              var backButtonPressed = true;
              // Call the callback function to notify the child widget
              if (backButtonPressed) {
                widget.onDeactivateProcessPdfMessage(true);
              }
              return Future.value(
                  true); // Return true to allow popping the route
            },
            child: SfPdfViewer.memory(widget.pdfbytes)));
  }
}
