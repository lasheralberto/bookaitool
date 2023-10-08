import 'dart:typed_data';

import 'package:bookaitool/Screens/PdfViewerMobile.dart';
import 'package:bookaitool/constants.dart';
import 'package:bookaitool/functions.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';

class SendButtonMobile extends StatefulWidget {
  List<Map<String, String>> contentAdded;
  List<String> ideasList;
  List<String> styleSelectedList;
  String formatSelected;
  String pageSize;
  void Function(bool) onBackPressed;
  void Function(Uint8List)? pdfData;
  int? price;

  SendButtonMobile(
      {Key? key,
      required this.contentAdded,
      required this.ideasList,
      required this.styleSelectedList,
      required this.formatSelected,
      required this.pageSize,
      required this.onBackPressed,
      required this.price,
      this.pdfData})
      : super(key: key);

  @override
  State<SendButtonMobile> createState() => _SendButtonMobileState();
}

class _SendButtonMobileState extends State<SendButtonMobile> {
  ButtonState? buttonState;
  bool? isReadyToSend;
  @override
  void initState() {
    super.initState();

    buttonState = ButtonState.idle;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        child: ProgressButton(
          radius: 10.0,
          padding: const EdgeInsets.all(5),
          progressIndicatorSize: 15.0,
          stateWidgets:   {
            ButtonState.idle: Text(
              "Get for: ${widget.price.toString()} €",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            ButtonState.loading: Text(
              "Loading",
              style:
                  TextStyle(color: Colors.yellow, fontWeight: FontWeight.w500),
            ),
            ButtonState.fail: Text(
              "Fail",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            ButtonState.success: Text(
              "Success",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            )
          },
          stateColors: {
            ButtonState.idle: widget.contentAdded.isNotEmpty
                ? ColorConstants.colorButtons
                : Colors.grey.shade400,
            ButtonState.loading: Colors.blue.shade300,
            ButtonState.fail: Colors.red.shade300,
            ButtonState.success: Colors.green.shade400,
          },
          onPressed: () async {
            if (widget.contentAdded.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please add at least one idea'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  });
            } else {
              await fetchPdfDataBytes(
                      widget.ideasList,
                      widget.styleSelectedList,
                      widget.formatSelected,
                      widget.pageSize,
                      context)
                  .then((value) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfScreenSyncFussionMobile(
                            onDeactivateProcessPdfMessage: (p0) {
                              setState(() {
                                widget.onBackPressed(p0);
                                buttonState = ButtonState.idle;
                                widget.pdfData!(value);
                              });
                            },
                            pdfbytes: value,
                          )),
                );
              });
            }
          },
          state: buttonState,
        ));
  }
}
