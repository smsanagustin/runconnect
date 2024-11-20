// firestore_service
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/services/user_firestore.dart';

part 'run_event_creator.g.dart';

@riverpod
class CreatorNotifier extends _$CreatorNotifier {
  @override
  Set<AppUser> build() {
    return const {};
  }

  // get user
  void getUser(String id) async {
    AppUser? appUser = await UserFirestoreService.getUser(id);
    if (appUser != null) {
      state = {appUser};
    }
  }
}

// read only
@riverpod
AppUser? eventCreator(ref) {
  final appUserSet = ref.watch(creatorNotifierProvider);
  AppUser? appUser;

  if (appUserSet != null) {
    appUser = appUserSet.first;
  }

  return appUser;
}
