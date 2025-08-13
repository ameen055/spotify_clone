import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_flutter/View/pages/profile_page.dart';
import '../../../Controller/utilities/pick_uploadfile.dart';
import '../../../Data/model/audios_model.dart';
import 'search.dart'; // Your SearchWidget

class BottomNavWidget extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const BottomNavWidget({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  final uploadService = UploadService();

  Future<void> _openSearch(BuildContext context) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('audios')
        .get();

    final songs = snapshot.docs.map((doc) {
      return Audios.fromFirestore(doc.data(), docId: '');
    }).toList();

    showSearch(context: context, delegate: SearchWidget(songs));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xffffffff),
      currentIndex: widget.selectedIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Colors.blue.shade500,
      unselectedItemColor: Colors.black12,
      items: const [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.house), // instead of Icons.home
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
          ), // instead of Icons.search
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.plus), // instead of Icons.add
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.heart), // instead of Icons.favorite
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.user), // instead of Icons.person
          label: 'Profile',
        ),
      ],
        onTap: (index) async {
          widget.onTabSelected(index);

          if (index == 1) {
            await _openSearch(context);
          } else if (index == 2) {
            await uploadService.pickAndUploadFile(context);
          }
          // No more Navigator.push for index 3 or 4
        }

    );
  }
}
