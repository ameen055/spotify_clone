import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter/View/widgets/home_widget/search.dart';

import '../../../Data/model/audios_model.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color(0xffffffff),
      elevation: 0,
      title: SizedBox(
        height: 120, // Control image height
        width: 120, // Control image width
        child: Image.asset('assets/Vector.jpg', fit: BoxFit.contain),
      ),
      leading: IconButton(
        padding: EdgeInsets.only(left: 30.0),
        icon: Icon(Icons.search),
        onPressed: () async {
          final snapshot = await FirebaseFirestore.instance
              .collection('audios')
              .get();

          final songs = snapshot.docs.map((doc) {
            return Audios.fromFirestore(doc.data());
          }).toList();

          // to open search
          showSearch(context: context, delegate: SearchWidget(songs));
        },
      ),
      actions: <Widget>[
        IconButton(
          padding: EdgeInsets.only(right: 30),
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xff000000),
          ), // The search icon
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
