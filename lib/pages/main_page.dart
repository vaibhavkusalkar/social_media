import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:social_media_material/pages/add_page.dart';
import 'package:social_media_material/pages/home_page.dart';
import 'package:social_media_material/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final page =[
    HomePage(),
    AddPost(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightDynamic
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkDynamic,
            ),
            home: Scaffold(
              body: page[index],
              /*floatingActionButtonLocation: ,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                onPressed: (){},
                child: const Icon(Icons.add),
              ),*/
              bottomNavigationBar: NavigationBar(
                //surfaceTintColor: Colors.white,
                selectedIndex: index,
                //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                onDestinationSelected: (index) =>
                    setState(() => this.index = index),
                destinations: [
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined, size: 28),
                      selectedIcon: Icon(Icons.home_rounded, size: 28),
                      label: "Home"
                  ),
                  NavigationDestination(
                      icon: Icon(Icons.add_circle_outline_rounded, size: 28),
                      selectedIcon: Icon(Icons.add_circle, size: 28),
                      label: "Add"
                  ),
                  NavigationDestination(
                      icon: Icon(Icons.account_circle_outlined, size: 28),
                      selectedIcon: Icon(
                          Icons.account_circle_rounded, size: 28),
                      label: "Account"
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
