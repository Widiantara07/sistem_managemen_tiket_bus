import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class MapProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> stations(LatLng location) async {
    QuerySnapshot querySnapshot = await _firestore.collection('station').get();
    List<Map<String, dynamic>> stations = [];
    for (var doc in querySnapshot.docs) {
      stations.add(doc.data() as Map<String, dynamic>);
    }
    return stations;
  }
}
