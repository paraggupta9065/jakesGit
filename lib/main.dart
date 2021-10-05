import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jake Wharton',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uri url = Uri.parse(
      """https://api.github.com/users/JakeWharton/repos?page=1&per_page=15""");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jake's Git"),
      ),
      body: FutureBuilder(
        future: http.get(url),
        builder:
            (BuildContext context, AsyncSnapshot<http.Response> rawSnapshot) {
          if (rawSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var snapshot = jsonDecode(rawSnapshot.data!.body);

          return ListView.builder(
            itemCount: snapshot.length,
            itemBuilder: (BuildContext context, int index) {
              return listTile(snapshot[index]);
            },
          );
        },
      ),
    );
  }
}

Widget listTile(dynamic data) {
  return ListTile(
    leading: Icon(
      Icons.book,
      color: Colors.black,
      size: 70,
    ),
    title: Text(
      data["name"],
    ),
    subtitle: SizedBox(
      height: 100,
      child: Column(
        children: [
          Flexible(
            child: Text(
              data["description"].toString(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              data["language"] != null
                  ? Icon(
                      Icons.code,
                      size: 15,
                    )
                  : SizedBox(),
              data["language"] != null
                  ? Text(
                      data["language"].toString(),
                      style: TextStyle(fontSize: 12),
                    )
                  : SizedBox(),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.bug_report,
                size: 15,
              ),
              Text(
                data["open_issues_count"].toString(),
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.face,
                size: 15,
              ),
              Text(
                data["watchers_count"].toString(),
                style: TextStyle(fontSize: 12),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
