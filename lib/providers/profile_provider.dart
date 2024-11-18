import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/services/firestore_service.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  // initial value

  @override
  Set<AppUser> build() {
    return const {};
  }

  // add logged in user to the set
  void addUser(String id) async {
    AppUser? appUser = await FirestoreService.getUser(id);
    if (appUser != null) {
      state = {appUser};
    }
  }

  // remove
  void removeUser() {
    state = {};
  }
}
