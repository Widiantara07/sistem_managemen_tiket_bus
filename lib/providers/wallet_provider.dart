import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class WalletProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _fireauth = FirebaseAuth.instance;

  Future<int> getWallet() async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(_fireauth.currentUser!.uid)
        .get();

    return querySnapshot.data()!['money'];
  }
}
