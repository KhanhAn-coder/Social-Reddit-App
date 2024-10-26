import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/providers/firebase_providers.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: ref.read(googleProvider),
    firestore: ref.read(fireStoreProvider),
    auth: ref.read(authProvider),
  )
);
class AuthRepository{
  final GoogleSignIn _googleSignIn ;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepository({
    required googleSignIn,
    required firestore,
    required auth}) : _googleSignIn = googleSignIn,
                      _firestore = firestore,
                      _auth = auth;

  Stream<User?> get  authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLoginScreen) async {
    try{
      UserCredential userCredential;
      if(kIsWeb){
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider);
      }else{
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        if(isFromLoginScreen){
          userCredential = await _auth.signInWithCredential(credential);
        }else{
          userCredential = await _auth.currentUser!.linkWithCredential(credential);
        }
      }


      UserModel userModel;
      if(userCredential.additionalUserInfo!.isNewUser){
        userModel = UserModel(
            name: userCredential.user!.displayName??'No name',
            profilePic: userCredential.user!.photoURL??Constants.avatarDefault,
            banner: Constants.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: [
              'awesomeAns',
              'gold',
              'platinum',
              'helpful',
              'plusone',
              'rocket',
              'thankyou',
              'til'
            ],
            contacts: [],
        );
        await _firestore.collection(FirebaseConstants.usersCollection).doc(userCredential.user!.uid).set(userModel.toMap());
      }else{
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);


    }on FirebaseException catch(e){
      throw e.message!;
    }
    catch(e){
      print(e);
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async{
    try{
      final userCredential = await _auth.signInAnonymously();
      UserModel userModel;
      if(userCredential.additionalUserInfo!.isNewUser){
        userModel = UserModel(
          name: 'Guest',
          profilePic: Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: false,
          karma: 0,
          awards: [],
          contacts: [],
        );
        await _firestore.collection(FirebaseConstants.usersCollection).doc(userModel.uid).set(userModel.toMap());
      }else{
        userModel  = await getUserData(userCredential.user!.uid).first;
      }


      return right(userModel);
    }on FirebaseException catch(e){
      throw e;
    }catch(e){
      return left(Failure(e.toString())) ;
    }
  }
  Stream<UserModel> getUserData(String uid){
    return _firestore.collection(FirebaseConstants.usersCollection).doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

}