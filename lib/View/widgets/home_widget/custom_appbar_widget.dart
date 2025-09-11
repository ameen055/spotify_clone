import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String imagePath; // <-- pass only the image path
  final bool hideBack;

  const BasicAppBar({super.key,
   this.hideBack = false,
    required this.imagePath,
    });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: hideBack ? null :Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            color:  Colors.white  ,
          ),
        ),
      ),
      centerTitle: true,
      title: Image.asset(
        imagePath,
        height: 130,
        width: 130,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
