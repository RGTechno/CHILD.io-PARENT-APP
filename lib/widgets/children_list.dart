import 'package:child_io_parent/color.dart';
import 'package:child_io_parent/screens/child_app_usage_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ChildrenList extends StatelessWidget {
  final List children;

  const ChildrenList({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
          child: Text(
            "My Children",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Divider(),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (_, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChildAppUsageScreen(
                      child: children[index],
                    ),
                  ),
                );
              },
              child: Card(
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
                  child: Row(
                    children: [
                      DottedBorder(
                        borderType: BorderType.Circle,
                        padding: EdgeInsets.all(30),
                        strokeWidth: 5,
                        color: accentColor,
                        borderPadding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            "${children[index]["firstName"][0]}",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                            "${children[index]["firstName"]} ${children[index]["lastName"]}"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            itemCount: children.length,
          ),
        ),
      ],
    );
  }
}
