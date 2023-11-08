import 'dart:async';
import 'dart:math';
import 'package:bookaitool/payment_configuration.dart';
import 'package:flutter/material.dart';
import 'package:bookaitool/DataListView.dart';
import 'package:bookaitool/custoAppBar.dart';
import 'package:bookaitool/constants.dart';
import 'package:pay/pay.dart';

class MyHomePageMobile extends StatefulWidget {
  const MyHomePageMobile({Key? key}) : super(key: key);

  @override
  _MyHomePageMobileState createState() => _MyHomePageMobileState();
}

class _MyHomePageMobileState extends State<MyHomePageMobile>
    with TickerProviderStateMixin {
  TextEditingController ideatextController = TextEditingController();
  TextEditingController styletextController = TextEditingController();

  List<String> ideasList = [];
  List<String> styleSelectedList = [];
  String formatSelected = '';
  String pageSize = '';
  String? randomWaitingMessage;
  bool triggerRandomMessage = false;
  late List<Map<String, String>> contentAdded;
  String? _currentMessage;
  late Stream<String> _messageStream;
  late StreamSubscription<String> _messageSubscription;
  int? price;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    contentAdded = [];
    pageSize = '';
    price = 0;
    _tabController = TabController(length: 2, vsync: this); // 2 tabs
  }

  final _paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorConstants.colortheme,
        appBar: CustomAppBar(
          title: '',
          hasTitle: false,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GooglePayButton(
          paymentConfiguration:
              PaymentConfiguration.fromJsonString(defaultGooglePay),
          paymentItems: _paymentItems,
          type: GooglePayButtonType.checkout,
          margin: const EdgeInsets.only(top: 15.0),
          onPaymentResult: (v) {},
          loadingIndicator: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        // SendButtonMobile(
        //   price: price,
        //   contentAdded: contentAdded,
        //   ideasList: ideasList,
        //   styleSelectedList: styleSelectedList,
        //   formatSelected: formatSelected,
        //   pageSize: pageSize,
        //   onBackPressed: (p0) {},
        // ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: ColorConstants.colorCard,
                  elevation: 20.0,
                  shadowColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: StyleConstants.border,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constrains) {
                        return ConstrainedBox(
                          constraints: constrains,
                          child: Column(
                            children: [
                              TextField(
                                minLines: 1,
                                maxLines: 3,
                                controller: ideatextController,
                                decoration: InputDecoration(
                                  labelText: 'Enter your idea',
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
                                        labelText: 'Image style',
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
                                          items:
                                              formatOptions.keys.map((option) {
                                            return DropdownMenuItem(
                                              value: option,
                                              child: Text(option),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                            labelText: 'Page Format',
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
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            labelText: 'Image quality',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  StyleConstants.border,
                                            ),
                                          ),
                                          items: pageSizeOptions.map((sizeMap) {
                                            String label = sizeMap.keys.first;

                                            return DropdownMenuItem<
                                                Map<String, double>>(
                                              value: sizeMap,
                                              child: Text(label),
                                            );
                                          }).toList(),
                                          onChanged: (v) {
                                            pageSize = v.toString();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstants.colorButtons,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: StyleConstants.border,
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  _addIdea(
                                    ideatextController.text,
                                    styletextController.text,
                                    formatSelected,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
          const Center(
            child: Text("Settings"),
          ),
        ]),
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
        formatSelected = '';

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
