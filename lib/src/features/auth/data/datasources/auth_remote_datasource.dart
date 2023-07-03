import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';


abstract class AuthRemoteDataSource{
  Future<UserModel> getUser();
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signInWithGoogle();
  Future<bool> signOut();
  Future<UserModel> signUp({required String email, required String name, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn
  });
  final fa.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  @override
  Future<UserModel> getUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if(firebaseUser == null){
      throw CustomException(message: 'Unauthenticated');
    }

    if(firebaseUser.displayName == null || firebaseUser.displayName == ''){
      return await getUserFromFirestore(firebaseUser);
    }

    return UserModel.fromFirebase(firebaseUser);
  }

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    fa.UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    return getUserFromFirestore(credential.user);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    fa.UserCredential? credential;

    if(kIsWeb) {
      final authProvider = GoogleAuthProvider();
      credential = await firebaseAuth.signInWithPopup(authProvider);
    } else {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if(googleUser == null){
        throw CustomException(message: 'Canceled');
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final googleCredential = fa.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      credential = await firebaseAuth.signInWithCredential(googleCredential);
    }
    return UserModel.fromFirebase(credential.user);
  }

  @override
  Future<bool> signOut() async {
    if (!kIsWeb) {
      await googleSignIn.signOut();
    }
    await firebaseAuth.signOut();
    return true;
  }

  @override
  Future<UserModel> signUp({required String email, required String name, required String password}) async {
    final fa.UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    return addUserToFirestore(credential.user, args: {'name': name});
  }

  Future<UserModel> addUserToFirestore(fa.User? firebaseUser, {Map<String, dynamic>? args}) async {
    if(firebaseUser != null) {
      return await firestore.collection('user').add({
        'email' : firebaseUser.email,
        'name' : args != null ? args['name'] : '',
        'uid' : firebaseUser.uid
      }).then((document){
        return document.get().then((querySnapshot) {
          return UserModel.fromJSON(querySnapshot.data());
        });
      }).catchError((error){
        throw CustomException(message: "Failed to add user: $error");
      });
    }
    throw CustomException(message: 'Unauthenticated');
  }

  Future<UserModel> getUserFromFirestore(fa.User? firebaseUser) async {
    if(firebaseUser != null) {
      return await firestore.collection('user')
      .where("uid", isEqualTo: firebaseUser.uid)
      .get()
      .then((querySnapshot) {
        return UserModel.fromJSON(querySnapshot.docs.first.data());
      }).onError((error, stackTrace){
        throw CustomException(message:'$error');
      });
    }
    throw CustomException(message: 'Unauthenticated');
  }

}