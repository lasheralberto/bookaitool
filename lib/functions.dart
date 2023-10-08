//stripe functions

library stripe;

import 'dart:convert';
import 'dart:typed_data';
import 'package:bookaitool/constants.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:js/js.dart';

Future<Uint8List> fetchPdfDataBytes(ideas, styles, format,pageSize, context) async {
  final response = await http
      .post(Uri.parse('https://doogiapp.azurewebsites.net/GeneratePdf/'),
          body: jsonEncode(<String, dynamic>{
            "spain_ideas": ideas,
            "styles_list": styles,
            "format": format,
            "page_size":pageSize
          }),
          headers: <String, String>{'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    print('Failed to fetch PDF data');
    throw Exception('Failed to fetch PDF data');
  }
}

//strype payment  https://fidev.io/stripe-checkout-in-flutter-web/
void redirectToCheckout(BuildContext _, quantity, priceId) async {
  final stripe = StripePay(PayConstants.private_key);
  stripe.redirectToCheckout(
    CheckoutOptions(
        lineItems: [
          LineItem(quantity: quantity, price: priceId),
        ],
        mode: 'payment',
        successUrl: 'http://localhost:52111/#/success',
        cancelUrl: 'http://localhost:52111/#/cancel'),
  );

  
  
}

@JS()
@anonymous
class StripePay {
  external StripePay(String key);
  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;
  external String get mode;
  external String get successUrl;
  external String get cancelUrl;
  external String get sessionId;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;
  external int get quantity;
  external factory LineItem({String price, int quantity});
}

