import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// username and password for team gmail
String username = 'team2133genome@gmail.com';
String password = 'xiGkat-hyvzek-6covda';

final _formKey = GlobalKey<FormState>();
final myController = TextEditingController();
final myController2 = TextEditingController();

Future sendEmail(String email, String message, {String name = "John Doe"}) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_7dws4pq';
  const templateId = 'template_0u8p0b9';
  const userId = 'eTpVjTPRKdcDqtCNE';

  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'from_name': name,
          'from_email': email,
          'reply_to': email,
          'message': message
        }
      }));
  return response.statusCode;
}

AlertDialog contact(context) {
  return AlertDialog(
    title: const Center(child: Text("Contact Us")),
    content: SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: Stack(children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (FirebaseAuth.instance.currentUser == null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: myController,
                    decoration: const InputDecoration(
                        labelText: 'Your Email', prefixIcon: Icon(Icons.email)),
                    validator: (emailValue) {
                      if (emailValue == null ||
                          emailValue.isEmpty ||
                          !emailValue.contains('@') ||
                          !emailValue.contains('.') ||
                          emailValue.indexOf('.') == (emailValue.length - 1)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: myController2,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your Message To The Team',
                      prefixIcon: Icon(Icons.message)),
                  validator: (messageValue) {
                    if (messageValue == null || messageValue.isEmpty) {
                      return "Please enter a valid message";
                    }
                    messageValue = '';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    ),
    actions: [
      Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 20,
          child: ElevatedButton(
              child: Text(
                "Submit",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 80,
                    color: Colors.black),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  sendEmail(
                      FirebaseAuth.instance.currentUser == null ? myController.value.text : FirebaseAuth.instance.currentUser!.email!,
                      myController2.value.text,
                      name: FirebaseAuth.instance.currentUser == null ? myController.value.text : FirebaseAuth.instance.currentUser!.uid,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sending email...')),
                  );
                  Navigator.pop(context);
                  myController.clear();
                  myController2.clear();
                }
              }),
        ),
      )
    ],
  );
}
