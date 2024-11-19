import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/screens/home/feed.dart';
import 'package:runconnect/screens/home/search.dart';
import 'package:runconnect/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController controller =
      PageController(); // controller for page view
  int currentPageIndex = 0;
  final tabPages = [
    const FeedScreen(),
    const SearchScreen(),
    const Text("host"),
    const Text("profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          backgroundColor: Colors.white,
          onDestinationSelected: (int index) {
            controller.jumpToPage(
                index); // switch to the page as specified by the index
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: AppColors.primaryColor,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person_add),
              icon: Icon(Icons.person_add_outlined),
              label: 'Add',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.add_box),
              icon: Icon(Icons.add_box_outlined),
              label: 'Host',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_circle),
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),

        // wrap with a page view to keep tabs consistent
        body: PageView(
          controller: controller,
          physics:
              const NeverScrollableScrollPhysics(), // disable scrolling to navigate between pages
          children: tabPages,
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ));
  }
}
