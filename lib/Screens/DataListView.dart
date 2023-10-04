import 'package:flutter/material.dart';

class DataListView extends StatefulWidget {
  final List<Map<String, String>> contentAdded;
  final void Function(Map<String, String> item, int index) onDeleteItem;
  final void Function(Map<String, String> item, int index) onEditItem;

  const DataListView(
      {Key? key,
      required this.contentAdded,
      required this.onDeleteItem,
      required this.onEditItem})
      : super(key: key);

  @override
  State<DataListView> createState() => _DataListViewState();
}

class _DataListViewState extends State<DataListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.contentAdded.length,
      itemBuilder: (context, index) {
        final row = widget.contentAdded[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Adjust the radius as needed
          ),
          elevation: 10.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Idea: ${row['idea'] ?? ''}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Style: ${row['style'] ?? ''}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Format: ${row['format'] ?? ''}'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.onDeleteItem(row, index);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_outlined),
                        onPressed: () {
                          setState(() {
                            widget.onEditItem(row, index);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
