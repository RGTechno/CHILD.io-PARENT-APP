import 'dart:convert';

import 'package:child_io_parent/color.dart';
import 'package:child_io_parent/constants.dart';
import 'package:child_io_parent/provider/auth_provider.dart';
import 'package:child_io_parent/widgets/children_list.dart';
import 'package:child_io_parent/widgets/dummy_children_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isloading = false;

  List children = [];
  var user;

  Future<void> getUserData() async {
    try {
      setState(() {
        _isloading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      var userData = await prefs.getString("user");
      var jsonUser = json.decode(userData!);
      setState(() {
        user = jsonUser;
        _isloading = false;
      });
      print(user);
    } catch (err) {
      print(err);
    }
  }

  Future<void> getChildren() async {
    try {
      setState(() {
        _isloading = true;
      });
      var url = Uri.https(apiHost, "/api/parent/children",
          {"userID": user?["userID"].toString()});
      var response = await http.get(url);
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["success"]) {
        setState(() {
          children = jsonResponse["data"];
          _isloading = false;
        });
        print(children);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> init() async {
    await getUserData();
    await getChildren();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return _isloading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: primaryColor,
              toolbarHeight: mediaQuery.height * 0.2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              title: Text(
                "Hey, ${user?["firstName"]} !", //TODO: username from data
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    children.isEmpty
                        ? DummyChildrenList()
                        : ChildrenList(children: children),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Connect to your child device"),
                            content: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Enter the below code to your child's app in LINK TO PARENT dialog",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      user["userID"].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 28,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "ADD CHILD",
                          style: TextStyle(fontSize: 20, color: textColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
