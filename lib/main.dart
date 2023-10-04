import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:bookaitool/Screens/LandingPage.dart';
import 'package:bookaitool/SendButton.dart';
import 'package:bookaitool/custoAppBar.dart';
import 'package:flutter/material.dart';
import 'package:bookaitool/Screens/DataListView.dart';
import 'package:bookaitool/constants.dart';
import 'package:bookaitool/functions.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'Screens/PdfViewer.dart';

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue, // Set the primary color to blue
        fontFamily: 'Roboto', // Use Google's Roboto font
      ),
      home: LandingPage(),
      routes: {'/home': (context) => const MyHomePage()},
      // Example: routes: {'/home': (context) => HomeScreen()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController ideatextController = TextEditingController();
  TextEditingController styletextController = TextEditingController();

  List<String> ideasList = [];
  List<String> styleSelectedList = [];
  String formatSelected = '';
  String? randomWaitingMessage;
  bool triggerRandomMessage = false;
  late List<Map<String, String>> contentAdded;
  String? _currentMessage;
  late Stream<String> _messageStream;
  late StreamSubscription<String> _messageSubscription;

  @override
  void initState() {
    super.initState();
    contentAdded = [];
    triggerRandomMessage = false;
    // Create a stream that emits random messages every second
    _messageStream =
        Stream.periodic(const Duration(seconds: 2), (_) => getRandomMessage());
    // Subscribe to the stream and update the current message
    _messageSubscription = _messageStream.listen((String message) {
      setState(() {
        triggerRandomMessage ? _currentMessage = message : _currentMessage = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colortheme,
      appBar: CustomAppBar(title: 'Book AI'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SendButtonScaffold(
          contentAdded: contentAdded,
          ideasList: ideasList,
          styleSelectedList: styleSelectedList,
          formatSelected: formatSelected,
          onBackPressed: (p0) {}),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: ColorConstants.colorCard,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: ideatextController,
                      decoration: InputDecoration(
                        labelText: 'Enter your idea',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
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
                              labelText: 'Image style',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _setStyle(styleSelectedList);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: formatSelected,
                      onChanged: (value) {
                        setState(() {
                          formatSelected = value.toString();
                        });
                      },
                      items: formatOptions.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Page Format',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _addIdea(ideatextController.text,
                            styletextController.text, formatSelected);
                      },
                      child: const Text('Add page'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            triggerRandomMessage == true
                ? Text(_currentMessage as String)
                : const SizedBox.shrink(),
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
                    contentAdded.remove(item);
                    _removeIdea(i);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setStyle(stylesList) {
    int min = 1;
    int max = allStyles.length;
    int randomNumber = min + Random().nextInt(max - min + 1);

    setState(() {
      styleSelectedList = [];
      styletextController.text = allStyles[randomNumber];
    });
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

  void _removeIdea(int i) {
    setState(() {
      ideasList.removeAt(i);
      styleSelectedList.removeAt(i);
    });
  }

  void _addIdea(String idea, String style, String format) {
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
        contentAdded.add({
          'idea': idea,
          'style': style,
          'format': format,
        });

        ideatextController.clear();
        styletextController.clear();
        formatSelected = "";

        ideasList.add(idea);
        styleSelectedList.add(style);
      });
    }
  }

  int getRandomNumber(int min, int max) {
    final Random random = Random();
    return random.nextInt(randomMessages.length);
  }

  String getRandomMessage() {
    return randomMessages[getRandomNumber(0, randomMessages.length)];
  }

  @override
  void dispose() {
    ideatextController.dispose();
    super.dispose();
  }
}
