import 'package:firebase_auth/firebase_auth.dart' as fa;

import '../../domain/entities/user.dart';

class UserModel extends User {
  
  const UserModel({
    required String email,
    required String id,
    required String name, 
    required String photo,
  }) : super(
    email: email,
    id: id,
    name: name,
    photo: photo
  );

  factory UserModel.fromJSON(dynamic json) {
    return UserModel(
      email: json['email'],
      id: json['uid'],
      name: json['name'],
      photo: json['photo'] ?? ''
    );
  }

  factory UserModel.fromFirebase(fa.User? firebaseUser) {
    return UserModel(
      email: firebaseUser!.email ?? '',
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      photo: firebaseUser.photoURL ?? ''
    );
  }

  static const empty = UserModel(email: '', id: '', name: '', photo: '');
}