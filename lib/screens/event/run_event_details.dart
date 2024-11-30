import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/models/run_event.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class RunEventDetailsScreen extends StatefulWidget {
  const RunEventDetailsScreen(
      {super.key, required this.runEvent, required this.creatorName});

  final RunEvent runEvent;
  final String creatorName;

  @override
  State<RunEventDetailsScreen> createState() => _RunEventDetailsScreenState();
}

class _RunEventDetailsScreenState extends State<RunEventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: StyledTitleMedium(widget.runEvent.title!),
          backgroundColor: AppColors.primaryColor),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
            vertical: 18.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StyledText("POSTED BY"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledTextStrong(widget.creatorName),
                        StyledText(DateFormat('MMMM dd, yyyy')
                            .format(DateTime.parse(widget.runEvent.date!)))
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const StyledText("JOINED"),
                    StyledTextStrong(
                        "${widget.runEvent.participants.length}/5"),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            // distance
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.directions_run, color: AppColors.textColor),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StyledTextBold("Distance"),
                    StyledText("${widget.runEvent.distance.toString()}K"),
                  ],
                )
              ],
            ),
            const Divider(),

            // when
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.calendar_today, color: AppColors.textColor),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StyledTextBold("When"),
                    StyledText(DateFormat('MMMM dd, yyyy')
                        .format(DateTime.parse(widget.runEvent.date!))),
                  ],
                )
              ],
            ),

            // where
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: AppColors.textColor),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StyledTextBold("Where"),
                    StyledText(widget.runEvent.location!),
                  ],
                )
              ],
            ),
            const Divider(),

            // meetup place
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.pin_drop, color: AppColors.textColor),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StyledTextBold("Meetup Place"),
                    StyledText(widget.runEvent.meetupPlace!),
                  ],
                )
              ],
            ),
            const Divider(),

            const SizedBox(
              height: 20,
            ),

            // participants
            const StyledTitleMedium("Participants"),

            //TODO:  show the icons of the participants instead of their names
            // then user can just click on it.
          ],
        ),
      ),
    );
  }
}
