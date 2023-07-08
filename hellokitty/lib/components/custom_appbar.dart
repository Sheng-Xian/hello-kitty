import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String iconPath;
  final Color backgroudColor;
  final double height;

  // const CustomAppBar({
  //   super.key,
  //   required this.title,
  //   required this.iconPath,
  //   required this.backgroudColor,
  //   required this.height,
  // });

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.backgroudColor,
    required this.height,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    const String heartPath = "assets/icons/manual-feeding.png";
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            iconPath,
            height: height / 1.5,
            color: iconPath == heartPath ? Colors.red : Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            title,
          ),
        ],
      ),
    );
  }
}
