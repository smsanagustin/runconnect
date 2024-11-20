import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runconnect/models/run_event.dart';
import 'package:runconnect/screens/event/run_event_details.dart';
import 'package:runconnect/shared/styled_button.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class RunEventContainer extends StatefulWidget {
  const RunEventContainer({super.key, required this.runEvent});

  final RunEvent runEvent;

  @override
  State<RunEventContainer> createState() => _RunEventContainerState();
}

class _RunEventContainerState extends State<RunEventContainer> {
  void _navigateToDetails(BuildContext context, RunEvent runEvent) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => RunEventDetailsScreen(runEvent: runEvent)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context, widget.runEvent),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // poster
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Image.network(
                    "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/cfca3f83-9e45-4fa4-a361-574cc7aa62f8/dfqkx8j-0297b5f2-4a39-46a9-b12c-2f6ce4d89ca4.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2NmY2EzZjgzLTllNDUtNGZhNC1hMzYxLTU3NGNjN2FhNjJmOFwvZGZxa3g4ai0wMjk3YjVmMi00YTM5LTQ2YTktYjEyYy0yZjZjZTRkODljYTQucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.qNOTax2dCrRMjEWbQFCykaUQqQJbhGdZ3qen285UHp4",
                    height: 40,
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
                  const StyledText("Taylor Swift")
                ]),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_outline,
                      color: AppColors.primaryColor,
                    ))
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            // title
            StyledTitleMedium(widget.runEvent.title!),

            const SizedBox(
              height: 5,
            ),

            // run type
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(20.0)),
                child: const StyledTextSmall("LONG RUN")),

            const SizedBox(
              height: 7,
            ),

            // details
            StyledText("Distance: ${widget.runEvent.distance}k"),
            StyledText(
                "When: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(widget.runEvent.date!))}"),
            const StyledText("Where: Silang, Cavite"),
            const StyledText("Meetup place: Jollibee Bayan"),
            const SizedBox(
              height: 10,
            ),

            // bottom details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledTextStrong(
                    "Joined: ${widget.runEvent.participants.length}/5"),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.comment_outlined,
                            color: AppColors.primaryColor)),
                    StyledButtonSmall(
                        text: "Join", color: "lightBlue", onPressed: () {})
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
