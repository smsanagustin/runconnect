import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/shared/styled_text.dart';

class ProfileDetails extends ConsumerWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(profileNotifierProvider);
    String fullName = "";
    String location = "";
    int numberOfFollowers = 0;
    int numberOfFollowing = 0;

    // get details from appUser
    if (appUser.isNotEmpty) {
      AppUser user = appUser.first;
      fullName = user.fullName;
      location = user.location;
      numberOfFollowers = user.idsOfFollowers.length;
      numberOfFollowing = user.idsOfFollowing.length;
    }

    if (appUser.isEmpty) {
      return const CircularProgressIndicator();
    } else {
      return Row(
        children: [
          Image.network(
            "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/cfca3f83-9e45-4fa4-a361-574cc7aa62f8/dfqkx8j-0297b5f2-4a39-46a9-b12c-2f6ce4d89ca4.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2NmY2EzZjgzLTllNDUtNGZhNC1hMzYxLTU3NGNjN2FhNjJmOFwvZGZxa3g4ai0wMjk3YjVmMi00YTM5LTQ2YTktYjEyYy0yZjZjZTRkODljYTQucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.qNOTax2dCrRMjEWbQFCykaUQqQJbhGdZ3qen285UHp4",
            height: 80,
            loadingBuilder: (BuildContext context,
                Widget
                    child, // ref: https://stackoverflow.com/questions/53577962/better-way-to-load-images-from-network-flutter
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Icon(Icons.image);
            },
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledTextStrong(fullName == "" ? "Name not set." : fullName),
              StyledText(location == "" ? "Location not set." : location),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  StyledText("$numberOfFollowing  Following"),
                  StyledText("  $numberOfFollowers  Followers")
                ],
              ),
            ],
          )
        ],
      );
    }
  }
}
