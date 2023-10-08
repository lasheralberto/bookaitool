import 'dart:typed_data';
import 'package:bookaitool/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:js' as js;


class PdfScreenSyncFussionDesktop extends StatefulWidget {
  final Uint8List pdfbytes;
  final void Function(bool) onDeactivateProcessPdfMessage;

  const PdfScreenSyncFussionDesktop({
    Key? key,
    required this.pdfbytes,
    required this.onDeactivateProcessPdfMessage,
  }) : super(key: key);

  @override
  State<PdfScreenSyncFussionDesktop> createState() =>
      _PdfScreenSyncFussionDesktopState();
}

class _PdfScreenSyncFussionDesktopState
    extends State<PdfScreenSyncFussionDesktop> {
  bool backButtonPressed = false;

  void savePdfLocally(pdfContent) {
    const fileName = 'example.pdf'; // Specify the desired file name

    // Call the JavaScript function
    js.context.callMethod('saveFile', [fileName, pdfContent]);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, cons) {
        return ConstrainedBox(
          constraints: cons,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16.0), // Adjust the radius as needed
            ),
            elevation: 4.0, // Add elevation for a card-like effect
            child: Column(
              children: [
                ListTile(
                  trailing: ElevatedButton(
                    onPressed: () async {
                      savePdfLocally(widget.pdfbytes);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          ColorConstants.colorButtons, // Background color
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: const Icon(
                      Icons.downloading_rounded,
                      size: 24.0, // Icon size
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                      height: cons.maxHeight - 100,
                      child: SfPdfViewer.memory(widget.pdfbytes)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
