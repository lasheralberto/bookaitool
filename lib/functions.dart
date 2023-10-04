import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Uint8List> fetchPdfDataBytes(
    ideas, styles, format, context) async {
 

  final response = await http
      .post(Uri.parse('https://doogiapp.azurewebsites.net/GeneratePdf/'),
          body: jsonEncode(<String, dynamic>{
            "spain_ideas": ideas,
            "styles_list": styles,
            "format": format,
          }),
          headers: <String, String>{'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    print('Failed to fetch PDF data');
    throw Exception('Failed to fetch PDF data');
  }
}
