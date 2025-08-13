import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter/View/pages/favourites.dart';
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
      backgroundColor: const Color(0xff42c83c),
      currentIndex: widget.selectedIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) async {
        if (index == 1) {
          // Search
          await _openSearch(context);
        } else if (index == 2) {
          // Add → pick and upload file
          await uploadService.pickAndUploadFile(context);
        } else if  (index == 3){
          Navigator.push(context, MaterialPageRoute(builder: (_) => FavouritePage()),
    );
        } else if (index == 4){
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()),
        );
      }
        },
    );
  }
}
