import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:bookaitool/Screens/PdfViewerDesktop.dart';
import 'package:bookaitool/SendbuttonDesktop.dart';
import 'package:bookaitool/custoAppBar.dart';
import 'package:bookaitool/onboardingSteps.dart';
import 'package:flutter/material.dart';
import 'package:bookaitool/DataListView.dart';
import 'package:bookaitool/constants.dart';

class MyHomePageDesktop extends StatefulWidget {
  const MyHomePageDesktop({Key? key}) : super(key: key);

  @override
  _MyHomePageDesktopState createState() => _MyHomePageDesktopState();
}

class _MyHomePageDesktopState extends State<MyHomePageDesktop> {
  TextEditingController ideatextController = TextEditingController();
  TextEditingController styletextController = TextEditingController();

  List<String> ideasList = [];
  List<String> styleSelectedList = [];
  String formatSelected = '';
  String pageSize = "";
  String? randomWaitingMessage;
  bool triggerRandomMessage = false;
  late List<Map<String, String>> contentAdded;
  String? _currentMessage;
  late Stream<String> _messageStream;
  late StreamSubscription<String> _messageSubscription;
  Uint8List? pdfData;
  int? price;

  @override
  void initState() {
    super.initState();
    contentAdded = [];
    pageSize = '';
    price = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colortheme,
      appBar: CustomAppBar(
        title: '',
        hasTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constr) {
            return ConstrainedBox(
              constraints: constr,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          margin: const EdgeInsets.all(20),

                          color: ColorConstants.colorCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                16.0), // Adjust the radius as needed
                          ),
                          elevation:
                              4.0, // Add elevation for a card-like effect
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              TextField(
                                minLines: 1,
                                maxLines: 3,
                                controller: ideatextController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white60,
                                  labelText: TextFieldsTexts.IdeaTextField,
                                  border: OutlineInputBorder(
                                    borderRadius: StyleConstants.border,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: 3,
                                      controller: styletextController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white60,
                                        labelText:
                                            TextFieldsTexts.StyleTextField,
                                        border: OutlineInputBorder(
                                          borderRadius: StyleConstants.border,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.lightbulb,
                                      color: ColorConstants.colorButtons,
                                    ),
                                    onPressed: () {
                                      _setStyle(styleSelectedList);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              LayoutBuilder(builder: (context, cons) {
                                return ConstrainedBox(
                                  constraints: cons,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField(
                                          isExpanded: true,
                                          value: formatSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              formatSelected = value.toString();
                                            });
                                          },
                                          items: formatOptions.map((option) {
                                            return DropdownMenuItem(
                                              enabled: contentAdded.isEmpty,
                                              value: option,
                                              child: Text(option),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white60,
                                            labelText:
                                                TextFieldsTexts.FormatTextField,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  StyleConstants.border,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      Expanded(
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white60,
                                            labelText: TextFieldsTexts
                                                .TextImageQuality,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  StyleConstants.border,
                                            ),
                                          ),
                                          items: pageSizeOptions.map((sizeMap) {
                                            String label = sizeMap.keys
                                                .first; // Get the label from the map key
                                            int? value = sizeMap[
                                                label]; // Get the value from the map value
                                            return DropdownMenuItem<
                                                Map<String, int>>(
                                              enabled: contentAdded.isEmpty,
                                              value: sizeMap,
                                              child: Text(label),
                                            );
                                          }).toList(),
                                          onChanged: (v) {
                                            pageSize = v!.keys
                                                .toString()
                                                .replaceAll('(', '')
                                                .replaceAll(')', '');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstants
                                      .colorButtons, // Background color
                                  foregroundColor: Colors.white, // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: StyleConstants
                                        .border, // Rounded corners
                                  ),
                                  padding: const EdgeInsets.all(
                                      16.0), // Button padding
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 24.0, // Icon size
                                ),
                                onPressed: () {
                                  _addIdea(
                                      ideatextController.text,
                                      styletextController.text,
                                      formatSelected,
                                      pageSize);

                                  setState(() {
                                    price = _calculatePrice(
                                        contentAdded.length, pageSize);
                                  });
                                },
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: DataListView(
                            contentAdded: contentAdded,
                            onEditItem: (item, i) {
                              setState(() {
                                _editItem(item);
                              });
                            },
                            onDeleteItem: (item, i) {
                              setState(() {
                                contentAdded.removeWhere((map) {
                                  // Compare the content of the map to determine if it should be removed
                                  // Assuming that 'item' is a map with the same structure as the items in 'contentAdded'
                                  return map['idea'] == item['idea'] &&
                                      map['style'] ==
                                          item[
                                              'style']; // Adjust the keys as needed
                                });
                                _removeIdea(i);
                                price = _calculatePrice(
                                    contentAdded.length, pageSize);
                              });
                            },
                          ),
                        ),
                        SendButtonDesktop(
                          contentAdded: contentAdded,
                          ideasList: ideasList,
                          styleSelectedList: styleSelectedList,
                          formatSelected: formatSelected,
                          pageSize: pageSize,
                          priceOfSubmit: price,
                          onBackPressed: (p0) {},
                          pdfData: (pdfbytes) {
                            setState(() {
                              pdfData = pdfbytes;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 3,
                    child: pdfData != null
                        ? PdfScreenSyncFussionDesktop(
                            pdfbytes: pdfData!, // Provide the PDF data here
                            onDeactivateProcessPdfMessage: (bool value) {},
                          )
                        : const Center(
                            // Display a loading or empty state when pdfData is null
                            child:
                                CreativeStepsWidget(), // Replace with your desired loading indicator or message
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _removeIdea(int i) {
    setState(() {
      ideasList.removeAt(i);
      styleSelectedList.removeAt(i);
    });
  }

  int _calculatePrice(int contentLen, String pageSize) {
    // Find the map that matches the pageSize
    var matchingPage = pageSizeOptions.firstWhere((pageMap) {
      return pageMap.keys.contains(pageSize);
    }, orElse: () => {"": 0}); // Default to {"": 0} if no match is found

    // Extract the price associated with the matched pageSize
    var priceOfPage = matchingPage[pageSize] ?? 0;

    var price = contentLen * priceOfPage;
    return price;
  }

  void _editItem(Map<String, String> item) {
    TextEditingController editedIdeaController = TextEditingController();
    TextEditingController editedStyleController = TextEditingController();

    editedIdeaController.text = item['idea'] ?? '';
    editedStyleController.text = item['style'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                minLines: 1,
                maxLines: 10,
                controller: editedIdeaController,
                decoration: const InputDecoration(
                  labelText: 'Idea',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                minLines: 1,
                maxLines: 3,
                controller: editedStyleController,
                decoration: const InputDecoration(
                  labelText: 'Style',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                item['idea'] = editedIdeaController.text;
                item['style'] = editedStyleController.text;

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _setStyle(stylesList) {
    int min = 1;
    int max = allStyles.length;
    int randomNumber = min + Random().nextInt(max - min + 1);

    setState(() {
      //styleSelectedList = [];
      styletextController.text = allStyles[randomNumber];
    });
  }

  void _addIdea(String idea, String style, String format, String pageSize) {
    if (idea.isEmpty || style.isEmpty || format.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill all the fields'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    } else {
      setState(() {
        contentAdded.add(
            {'idea': idea, 'style': style, 'format': format, 'size': pageSize});

        ideatextController.clear();
        styletextController.clear();
        //formatSelected = "";

        ideasList.add(idea);
        styleSelectedList.add(style);
      });
    }
  }

  @override
  void dispose() {
    ideatextController.dispose();
    super.dispose();
  }
}
