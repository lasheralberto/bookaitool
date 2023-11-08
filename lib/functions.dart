//stripe functions

library stripe;

import 'dart:convert';
import 'package:bookaitool/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:js/js.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Map<String, dynamic>> fetchPdfDataBytes(
    Map<String, String> introList,
    List<String> langlist,
    List<String> ideas,
    List<String> styles,
    List<double> format,
    String pageSize,
    String pageOrChapter,
    context) async {
  List<String> languageList = langlist.toSet().toList();

  final response = await http
      .post(Uri.parse('https://doogiapp.azurewebsites.net/GeneratePdf/'),
          body: jsonEncode(<String, dynamic>{
            "intro_variables": introList,
            "lang_list": languageList,
            "ideas_list": ideas,
            "styles_list": styles,
            "format": format,
            "img_size": pageSize,
            "manual_intro": true,
            "open_ai_key": ApiKeys.open_ai_key
          }),
          headers: <String, String>{'Content-Type': 'application/json'});

  introList.clear();
  languageList.clear();
  ideas.clear();
  styles.clear();
  format.clear();
  pageSize = '';
  pageOrChapter = '';

  return {'statusCode': response.statusCode, 'pdfData': response.bodyBytes};
}

Future<void> launchStripePaymentPage() async {
  const url = "https://buy.stripe.com/cN28AAfNH9g89C8288";

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<dynamic> createTestPaymentSheet(amount, currency) async {
  final response = await http.post(
      Uri.parse('https://doogiapp.azurewebsites.net/PayStripe/'),
      body:
          jsonEncode(<String, dynamic>{"amount": amount, "currency": currency}),
      headers: <String, String>{'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    //Step 2: Initialize payment sheet
    var paymentIntent = response.body;
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent,
          style: ThemeMode.dark,
          merchantDisplayName: 'InkWiz',
        ))
        .then((value) => {});

    //Step 3: Display payment sheet
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) => {print('Success')});
    } catch (e) {}
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
        successUrl: 'http://localhost:57329/#/success',
        cancelUrl: 'http://localhost:57329/#/cancel'),
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

void payment(amount) async {
  Map<String, dynamic>? paymentIntent;
  try {
    Map<String, dynamic> body = {'amount': amount, 'currency': 'EUR'};

    var response =
        await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
            headers: {
              'Authorization': 'Bearer ${PayConstants.private_key}',
              'Content-type': 'application/x-www-form-urlencoded'
            },
            body: body);

    paymentIntent = json.decode(response.body);
  } catch (error) {
    rethrow;
  }
}
