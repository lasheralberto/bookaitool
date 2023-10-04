import 'dart:io';
import 'dart:typed_data';
import 'package:bookaitool/constants.dart';
import 'package:bookaitool/custoAppBar.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfDisplay extends StatefulWidget {
  final Uint8List pdfDataBytes;
  Function(bool) deactivateRandomMessage;

  PdfDisplay(
      {super.key,
      required this.pdfDataBytes,
      required this.deactivateRandomMessage});

  @override
  State<PdfDisplay> createState() => _PdfDisplayState();
}

class _PdfDisplayState extends State<PdfDisplay> {
  late PdfControllerPinch pdfController;

  @override
  void initState() {
    pdfController =
        PdfControllerPinch(document: PdfDocument.openData(widget.pdfDataBytes));
    super.initState();
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }

  Future<void> savePdfToUserSelectedLocation(Uint8List pdfDataBytes) async {
    const typeGroup = XTypeGroup(label: 'PDF', extensions: ['pdf']);

    final result = await getSaveLocation(
        acceptedTypeGroups: [typeGroup], suggestedName: 'suggested_name.pdf');

    if (result != null) {
      final directory = Directory(result.path);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      const pdfFileName = 'suggested_name.pdf';
      final pdfFilePath = '${result.path}/$pdfFileName';

      File pdfFile = File(pdfFilePath);

      await pdfFile.writeAsBytes(pdfDataBytes);

      // Show a confirmation dialog or message
      print('PDF Saved: $pdfFilePath');
    } else {
      // User canceled the save operation
      print('Save operation canceled');
    }
  }

  Widget pdfView() => PdfViewPinch(
      controller: pdfController,
      onDocumentLoaded: (msg) {
        widget.deactivateRandomMessage(false);
      },
      onDocumentError: (error) {
        print(error.toString());
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colortheme,
      floatingActionButton: IconButton(
        icon: const Icon(Icons.download),
        onPressed: () async {
          await savePdfToUserSelectedLocation(widget.pdfDataBytes);
        },
      ),
      appBar: CustomAppBar(title: 'Your pdf is ready!'),
      body: Center(
        child: pdfView(),
      ),
    );
  }
}

class PdfScreenSyncFussion extends StatelessWidget {
  Uint8List pdfbytes;
  void Function(bool) onDeactivateProcessPdfMessage;
  bool backButtonPressed = false;

  PdfScreenSyncFussion(
      {Key? key,
      required this.pdfbytes,
      required this.onDeactivateProcessPdfMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colortheme,
        appBar: CustomAppBar(
          title: 'Your pdf is ready!',
        ),
        body: WillPopScope(
            onWillPop: () {
              // Handle the back button press here
              var backButtonPressed = true;
              // Call the callback function to notify the child widget
              if (backButtonPressed) {
                onDeactivateProcessPdfMessage(true);
              }
              return Future.value(
                  true); // Return true to allow popping the route
            },
            child: SfPdfViewer.memory(pdfbytes)));
  }
}
