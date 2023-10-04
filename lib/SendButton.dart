import 'package:bookaitool/Screens/PdfViewer.dart';
import 'package:bookaitool/functions.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';

class SendButtonScaffold extends StatefulWidget {
  List<Map<String, String>> contentAdded;
  List<String> ideasList;
  List<String> styleSelectedList;
  String formatSelected;
  void Function(bool) onBackPressed;

  SendButtonScaffold(
      {Key? key,
      required this.contentAdded,
      required this.ideasList,
      required this.styleSelectedList,
      required this.formatSelected,
      required this.onBackPressed})
      : super(key: key);

  @override
  State<SendButtonScaffold> createState() => _SendButtonScaffoldState();
}

class _SendButtonScaffoldState extends State<SendButtonScaffold> {
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
          padding: EdgeInsets.all(5),
          progressIndicatorSize: 20.0,
          stateWidgets: const {
            ButtonState.idle: Text(
              "Send",
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
                ? Colors.green
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
              setState(() {
                widget.onBackPressed(true);
                buttonState = ButtonState.loading;
              });

              await fetchPdfDataBytes(widget.ideasList,
                      widget.styleSelectedList, widget.formatSelected, context)
                  .then((value) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfScreenSyncFussion(
                            onDeactivateProcessPdfMessage: (p0) {
                              setState(() {
                                widget.onBackPressed(p0);
                                buttonState = ButtonState.idle;
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
