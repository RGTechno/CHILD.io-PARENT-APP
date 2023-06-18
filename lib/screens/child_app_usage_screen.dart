import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../color.dart';
import '../constants.dart';
import '../provider/auth_provider.dart';
import 'package:http/http.dart' as http;

class ChildAppUsageScreen extends StatefulWidget {
  final Map child;

  const ChildAppUsageScreen({Key? key, required this.child}) : super(key: key);

  @override
  State<ChildAppUsageScreen> createState() => _ChildAppUsageScreenState();
}

class _ChildAppUsageScreenState extends State<ChildAppUsageScreen> {
  List childAppUsage = [];
  int totalTime = 0;

  String coins = "";

  Future<void> getChildAppUsage() async {
    var url = Uri.https(apiHost, "/api/child/app-usage",
        {"userID": widget.child["userID"].toString()});
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body);
    if (jsonResponse["success"]) {
      double totalDuration = 0;
      jsonResponse["data"].forEach((app) => totalDuration += app["duration"]);
      setState(() {
        childAppUsage = jsonResponse["data"];
        totalTime = (totalDuration * 60000).toInt();
      });
      print(childAppUsage);
    }
  }

  Future<void> init() async {
    await getChildAppUsage();
  }

  String formatDuration(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return double.parse(hours) >= 1
        ? "$hours hrs $minutes mins"
        : "$minutes mins";
  }

  Future<void> incentiviseChild() async {
    if (coins.isEmpty) {
      return;
    }
    Navigator.of(context).pop();
    try {
      var url = Uri.https(apiHost, "/api/parent/incentivise-child");
      var response = await http.post(url,
          body: json.encode({
            "childID": widget.child["userID"],
            "coins": int.parse(coins),
          }),
          headers: {'Content-Type': 'application/json'});
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse["success"] == true) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Success"),
            content: Text(jsonResponse["message"]),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("OOPS"),
            content: Text(jsonResponse["message"]),
          ),
        );
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        toolbarHeight: mediaQuery.height * 0.15,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(30),
        //     bottomRight: Radius.circular(30),
        //   ),
        // ),
        title: Text(
          "${widget.child["firstName"]}'s Usage",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
            },
            icon: Icon(Icons.logout, size: 24),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: init,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: mediaQuery.height * 0.20,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: primaryColor,
                image: DecorationImage(
                    image: AssetImage("assets/images/bg_cover.png"),
                    fit: BoxFit.cover),
              ),
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Expanded(
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.location_on_outlined),
                  //       Expanded(
                  //         child: Text(
                  //           currentLocationString,
                  //           // overflow: TextOverflow.ellipsis,
                  //           softWrap: true,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Center(
                    child: Text(
                      formatDuration(totalTime),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Today's Total Usage",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Send Coins"),
                        content: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Amount",
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              coins = value;
                            });
                          },
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: <Widget>[
                          TextButton(
                            onPressed: incentiviseChild,
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(horizontal: 20),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: primaryColor),
                    child: Text(
                      "Incentivise",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        offset: Offset(0, 2),
                        spreadRadius: 20,
                        color: Colors.white38,
                      ),
                    ]),
                child: ListView.builder(
                  itemCount: childAppUsage.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          title: Text(
                            childAppUsage[index]["app"],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('d MMM y hh:mm a').format(
                              DateTime.parse(
                                  childAppUsage[index]["activityDate"]),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          trailing: Text(
                            formatDuration(
                              childAppUsage[index]["duration"] * 60000,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
