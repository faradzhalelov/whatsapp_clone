import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsup/common/utils/utils.dart';
import 'package:whatsup/features/auth/screens/otp_screen.dart';
import 'package:whatsup/features/auth/screens/user_information_screen.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({required this.auth, required this.firestore});

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.pushNamed(context, OTPScreen.routeName, arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void _navigateToUserInformation({required BuildContext context}) {
    Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
            (route) => false
    );
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider
          .credential(verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      _navigateToUserInformation(context: context);
    } on FirebaseAuthException catch(e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = avatarImageUrl;
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepository)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}