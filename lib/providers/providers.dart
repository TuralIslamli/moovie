import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<String> authErrorProvider = StateProvider<String>((ref) => "");
StateProvider<bool> signInSuccessProvider = StateProvider<bool>((ref) => false);
StateProvider<String> signUpErrorProvider = StateProvider<String>((ref) => "");
StateProvider<bool> signUpSuccessProvider = StateProvider<bool>((ref) => false);
StateProvider<bool> passResetSuccesProvider =
    StateProvider<bool>((ref) => false);

StateProvider<bool> uploadPictureProvider = StateProvider<bool>((ref) => false);
StateProvider<bool> isVideoPlaying = StateProvider<bool>((ref) => false);

StateProvider<int> selectedIndex = StateProvider<int>((state) => 0);
