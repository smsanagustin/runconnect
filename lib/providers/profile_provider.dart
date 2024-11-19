import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/models/run_event.dart';
import 'package:runconnect/services/user_firestore.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  // initial value

  @override
  Set<AppUser> build() {
    return const {};
  }

  // add logged in user to the set
  void setUser(String id) async {
    AppUser? appUser = await UserFirestoreService.getUser(id);
    if (appUser != null) {
      state = {appUser};
    }
  }

  // update current user
  void updateUser(AppUser appUser) {
    state = {appUser};

    // also save the update to firestore
    UserFirestoreService.updateUser(appUser);
  }

  // remove
  void removeUser() {
    state = {};
  }
}
