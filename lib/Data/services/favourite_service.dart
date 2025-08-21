// favorites_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static final _firestore = FirebaseFirestore.instance;
  static Set<String> _favoritedIds = {};
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFavorites();
  }

  static Future<void> _loadFavorites() async {
    try {
      // Load from Firestore
      final snapshot = await _firestore
          .collection('audios')
          .where('isFavourite', isEqualTo: true)
          .get();

      _favoritedIds = Set.from(snapshot.docs.map((doc) => doc.id));

      // Save to local cache
      await _prefs?.setStringList('favorites', _favoritedIds.toList());
    } catch (e) {
      // Fallback to local cache
      _favoritedIds = Set.from(_prefs?.getStringList('favorites') ?? []);
    }
  }

  static bool isFavorite(String songId) => _favoritedIds.contains(songId);

  static Future<void> toggleFavorite(String songId) async {
    final isFavorite = !_favoritedIds.contains(songId);

    // Update local state
    if (isFavorite) {
      _favoritedIds.add(songId);
    } else {
      _favoritedIds.remove(songId);
    }

    // Update local cache
    await _prefs?.setStringList('favorites', _favoritedIds.toList());

    // Update Firestore
    await _firestore.collection('audios').doc(songId).update({
      'isFavourite': isFavorite,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> get favoritesStream => _firestore
      .collection('audios')
      .where('isFavourite', isEqualTo: true)
      .snapshots();
}