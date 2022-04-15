import 'package:flutter/material.dart';

AlertDialog contact (context) {
  return AlertDialog(
    title: const Center(child: Text("Contact Us")),
    content: SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: Stack(
          children: [
            Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Your Email',
                          prefixIcon: Icon(Icons.email)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Your Message To The Team',
                          prefixIcon: Icon(Icons.message)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
      ),
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
                    color: Colors.black
                ),
              ),
              onPressed: () {
                // your code
              }),
        ),
      )
    ],
  );
}