import 'package:flutter/material.dart';

List<Map> QnA = [ // TODO: import Q&A as JSON asset file
  {
    "Title" : "General Questions",
    "Content" : {
      "Question" : "What can I do with this app?",
      "Answer" : "The purpose of this application is to allow both researchers and the general"
    }
  },
  {
    "Title" : "Variant Questions",
    "Content" : [
      {
        "Question" : "Where do these variants come from?",
        "Answer" : "All of these variants are retrieved from the NCBI database"
      },
      {
        "Question" : "Where can I find more details?",
        "Answer" : 'To find more details on a variant click on the hyperlinked variant, '
            ' this will bring you to the NCBI details on that strand. Here you'
            ' will find both the FASTA download for the sequence and its ID.'
      },
      {
        "Question" : "How do I compare a variant against another variant",
        "Answer" : 'Right now you cannot as it is not implemented in this iteration. However,'
            ' in the future the summary for a variant will have'
      }
    ]
  },
  {
    "Title" : "Region Questions",
    "Content" : {
      "Question" : "Why separate based off region?",
      "Answer" : "Separating by region allows you to look at the developments of"
          " variants within a select area. As mutations may be influenced by the "
          "diversity of individuals within a region, as seen in areas of high "
          "travel, as  more variants are introduced into the pool of competition."
    }
  },
  {
    "Question" : "Account Questions",
    "Answer" : "What can I do with this app?"
  },
  {
    "Question" : "Errors",
    "Answer" : "What can I do with this app?"
  }
];

AlertDialog faq (context) {
  return AlertDialog(
    title: const Center(child: Text("FAQ")),
    content: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 2,
        child: recursiveList(QnA)
    ),
  );
}

Widget recursiveList (content) { // TODO: get rid of text jitter on collapse
  if (content is List) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: content.length,
        itemBuilder: (context, index) {
          if (content[index].containsKey("Question")) {
            return ExpansionTile(
              textColor: Colors.black,
              title: Text(content[index]["Question"]),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(content[index]["Answer"]),
                )
              ],
            );
          }
          return ExpansionTile(
            textColor: Colors.black,
            title: Text(content[index]["Title"]),
            children: [ListTile(subtitle: recursiveList(content[index]["Content"]))],
          );
      },
    );
  }
  return ExpansionTile(
    textColor: Colors.black,
    title: Text(content["Question"]),
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(content["Answer"]),
      )
    ]
  );
}