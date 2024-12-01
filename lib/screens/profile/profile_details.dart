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
          ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: Image.network(
              "https://i0.wp.com/e-quester.com/wp-content/uploads/2021/11/placeholder-image-person-jpg.jpg?fit=820%2C678&ssl=1",
              height: 80,
              width: 80,
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
