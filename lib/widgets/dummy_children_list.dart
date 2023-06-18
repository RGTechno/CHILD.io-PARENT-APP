import 'package:child_io_parent/color.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DummyChildrenList extends StatelessWidget {
  const DummyChildrenList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 8),
      margin: EdgeInsets.symmetric(vertical: 15,horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        itemBuilder: (_, i) => DottedBorder(
          borderType: BorderType.Circle,
          radius: Radius.circular(12),
          padding: EdgeInsets.all(6),
          strokeWidth: 5,
          color: accentColor,
          borderPadding: EdgeInsets.all(10),
          child: Center(
            child: Icon(
              Icons.add,
              color: textColor.withOpacity(0.4),
              size: 28,
            ),
          ),
        ),
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
      ),
    );
  }
}
