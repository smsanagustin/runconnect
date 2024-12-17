import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/services/user_firestore.dart';

Future<String?> fetchEventCreatorName(String id) async {
  AppUser? appUser = await UserFirestoreService.getUser(id);

  if (appUser != null) {
    return appUser.fullName;
  }
  return null;
}
