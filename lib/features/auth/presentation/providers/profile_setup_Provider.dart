// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../completeProfile/domain/models/profile_setup_state.dart';

// final profileSetupProvider =
//     NotifierProvider<ProfileSetupNotifier, ProfileSetupState>(
//   ProfileSetupNotifier.new,
// );

// class ProfileSetupNotifier extends Notifier<ProfileSetupState> {
//   // final _supabase = Supabase.instance.client;

//   @override
//   ProfileSetupState build() {
//     return const ProfileSetupState();
//   }

//   // -------------------------
//   // Setters
//   // -------------------------

//   void setAvatar(String? url) {
//     state = state.copyWith(avatarUrl: url);
//   }

//   void setCity(String city) {
//     state = state.copyWith(city: city);
//   }

//   void setLocation({
//     required double latitude,
//     required double longitude,
//   }) {
//     state = state.copyWith(
//       latitude: latitude,
//       longitude: longitude,
//     );
//   }




 

//   // -------------------------
//   // Save Profile Data
//   // -------------------------

//   // Future<void> saveProfile() async {
//   //   try {
//   //     final user = _supabase.auth.currentUser;

//   //     if (user == null) {
//   //       setError('User not authenticated');
//   //       return;
//   //     }

//   //     if (state.city.isEmpty ||
//   //         state.latitude == null ||
//   //         state.longitude == null) {
//   //       setError('Please complete all required fields');
//   //       return;
//   //     }

//   //     setLoading(true);

//   //     await _supabase.from('profiles').update({
//   //       'avatar_url': state.avatarUrl,
//   //       'city': state.city,
//   //       'latitude': state.latitude,
//   //       'longitude': state.longitude,
//   //       'updated_at': DateTime.now().toIso8601String(),
//   //     }).eq('id', user.id);

//   //     setLoading(false);
//   //   } catch (e) {
//   //     setError(e.toString());
//   //   }
//   // }
// }