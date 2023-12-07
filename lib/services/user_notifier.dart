// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moovie/screens/profile/deleted_profile.dart';
import 'package:moovie/screens/profile/profile_screen.dart';
import '../const/constants.dart';
import '../models/user_model.dart';
import '../providers/providers.dart';

class UserServiceNotifier extends StateNotifier<List<UserModel>> {
  UserServiceNotifier() : super([]);

  final userDetails = FirebaseFirestore.instance
      .collection('users')
      .withConverter(fromFirestore: (snapshot, _) {
    return UserModel.fromJson(
      snapshot.data()!,
    );
  }, toFirestore: (model, _) {
    return model.toJson();
  });

  Future<void> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password,
      required BuildContext context,
      required WidgetRef ref}) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffec5500),
            ),
          );
        });
    final auth = FirebaseAuth.instance;
    File photoFile = await getImageFileFromAssets();

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      ref.read(signUpErrorProvider.notifier).update((state) => "");
      ref.read(signUpSuccessProvider.notifier).update((state) => true);

      Reference profilePictureReference = FirebaseStorage.instance
          .ref()
          .child("profilePictures/${auth.currentUser!.uid}");
      await profilePictureReference.putFile(photoFile);
      String photoURL = await profilePictureReference.getDownloadURL();
      await auth.currentUser!.updateDisplayName(name);
      await auth.currentUser!.updatePhotoURL(photoURL);
      await auth.signInWithEmailAndPassword(email: email, password: password);
      final User user = auth.currentUser!;
      FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'id': user.uid,
          'email': user.email,
          'name': user.displayName,
          'avatar': user.photoURL,
          'signUpTime': user.metadata.creationTime,
        },
        SetOptions(merge: true),
      );
    } on FirebaseAuthException catch (e) {
      ref.read(signUpSuccessProvider.notifier).update((state) => false);
      ref
          .read(signUpErrorProvider.notifier)
          .update((state) => e.message.toString());
      debugPrint("Error: ${e.message}");
    }
    Navigator.of(context).pop();
  }

  Future<void> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context,
      required WidgetRef ref}) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffec5500),
            ),
          );
        });
    final auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      ref.read(authErrorProvider.notifier).update((state) => "");
      ref.read(signInSuccessProvider.notifier).update((state) => true);
    } on FirebaseAuthException catch (e) {
      debugPrint("Error: ${e.message}");
      ref.read(signInSuccessProvider.notifier).update((state) => false);
      ref.read(authErrorProvider.notifier).update((state) => e.message!);
    }
    Future.delayed(const Duration(milliseconds: 250));
    Navigator.of(context).pop();
  }

  Future<void> logOut(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffec5500),
            ),
          );
        });

    final auth = FirebaseAuth.instance;
    try {
      await Future.delayed(const Duration(milliseconds: 500))
          .then((value) => auth.signOut());
    } on FirebaseAuthException catch (e) {
      debugPrint("Error: ${e.message}");
    }
    Navigator.of(context).pop();
  }

  Future<void> deleteProfile(BuildContext context) async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (builder) => const DeletedProfileScreen()));
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffec5500),
            ),
          );
        });

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete()
          .then((value) async => await FirebaseStorage.instance
              .ref()
              .child(
                  "profilePictures/${FirebaseAuth.instance.currentUser!.uid}")
              .delete())
          .then((value) async =>
              await FirebaseAuth.instance.currentUser!.delete());
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint(e.toString());
    }
    Navigator.of(context).pop();
  }

  updateProfile({
    required String name,
    required String bio,
    required String email,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffec5500),
            ),
          );
        });
    final User user = FirebaseAuth.instance.currentUser!;

    try {
      await user.updateDisplayName(name);
      await user.updateEmail(email);
      ref.read(authErrorProvider.notifier).update((state) => "");
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          "name": name,
          "bio": bio,
          "email": email,
        },
        SetOptions(merge: true),
      );
      ref.read(authErrorProvider.notifier).update((state) => "");
      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (builder) => const ProfileScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      ref.read(authErrorProvider.notifier).update((state) => e.message!);
      Navigator.of(context).pop();
    }
  }

  Future<void> changeAvatar(WidgetRef ref) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 100,
    );
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    late File? file;
    final Reference profilePictureReference = FirebaseStorage.instance
        .ref()
        .child("profilePictures/${auth.currentUser!.uid}");
    final collection = FirebaseFirestore.instance.collection("users");

    ref.read(uploadPictureProvider.notifier).update((state) => !state);
    if (image != null) {
      file = File(image.path);
    } else {
      ref.read(uploadPictureProvider.notifier).update((state) => !state);
    }
    if (file != null) {
      await profilePictureReference.putFile(file);
      String fileUrl = await profilePictureReference.getDownloadURL();
      try {
        await collection.doc(user!.uid).update({'avatar': fileUrl});
        await user.updatePhotoURL(fileUrl);
        ref.read(uploadPictureProvider.notifier).update((state) => !state);
      } catch (e) {
        ref.read(uploadPictureProvider.notifier).update((state) => !state);
      }
    } else {
      ref.read(uploadPictureProvider.notifier).update((state) => !state);
    }
  }

  Future<void> resetPassword({
    required String oldPass,
    required String newPass,
    required String retryNewPass,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffec5500),
            ),
          );
        });
    final User user = FirebaseAuth.instance.currentUser!;

    final credential =
        EmailAuthProvider.credential(email: user.email!, password: oldPass);
    try {
      await user.reauthenticateWithCredential(credential);
      ref.read(authErrorProvider.notifier).update((state) => "");
      ref.read(passResetSuccesProvider.notifier).update((state) => true);
      if (newPass != retryNewPass) {
        ref.read(passResetSuccesProvider.notifier).update((state) => false);
        ref
            .read(authErrorProvider.notifier)
            .update((state) => "New password is not same");
      } else {
        ref.read(authErrorProvider.notifier).update((state) => "");
        ref.read(passResetSuccesProvider.notifier).update((state) => true);
        try {
          await user.updatePassword(newPass);
        } on FirebaseAuthException catch (e) {
          ref.read(passResetSuccesProvider.notifier).update((state) => false);
          ref.read(authErrorProvider.notifier).update((state) => e.message!);
        }
      }
    } on FirebaseAuthException {
      ref.read(passResetSuccesProvider.notifier).update((state) => false);
      ref
          .read(authErrorProvider.notifier)
          .update((state) => "Old password is incorrect");
    }

    Navigator.of(context).pop();
  }

  Future<void> likeMovie({
    required String id,
    required String title,
    required String posterPath,
    required String backdropPath,
    required String releaseDate,
    required String overview,
    required String voteAverage,
    required String voteCount,
    required String videoId,
    required List<int> genreIds,
    required List<String> genres,
    required String genreView,
  }) async {
    var result = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("likedMovies");
    var snapshots = await result.where("id", isEqualTo: id.toString()).get();

    if (snapshots.docs.isEmpty) {
      return await result.doc(id.toString()).set(
          {
            "id": id.toString(),
            "title": title,
            "posterPath": posterPath,
            "backdropPath": backdropPath,
            "releaseDate": releaseDate,
            "overview": overview,
            "voteAverage": voteAverage,
            "voteCount": voteCount,
            "videoId": videoId,
            "genreIds": genreIds,
            "genres": genres,
            "genreView": genreView,
            "time": DateTime.now()
          },
          SetOptions(
            merge: true,
          ));
    } else {
      return await result.doc(id.toString()).delete();
    }
  }
}

final likeStreamProvider =
    StreamProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>((ref) {
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  var stream = FirebaseFirestore.instance
      .collection("users")
      .doc(userUid)
      .collection("likedMovies")
      .snapshots();
  return stream;
});

final userStreamProvider = StreamProvider.autoDispose<List<UserModel?>>(
  (ref) {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    var stream = FirebaseFirestore.instance.collection('users').snapshots();

    return stream.map((snapshot) {
      var data = snapshot.docs.map((doc) {
        if (doc.id == userUid) {
          return UserModel.fromJson(doc.data());
        }
      }).toList();
      return data.whereType<UserModel>().toList();
    });
  },
);

final userServiceProvider =
    StateNotifierProvider<UserServiceNotifier, List<UserModel>>(
        (ref) => UserServiceNotifier());
