import 'package:flutter/material.dart';
import 'package:restoguh/ui/screens/restaurant_list_screen.dart';
import 'package:restoguh/ui/screens/restaurant_detail_screen.dart';
import 'package:restoguh/ui/screens/restaurant_search_screen.dart';
import 'data/model/restaurant_list_model.dart';
import 'common/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restoguh',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.amber,
              onPrimary: Colors.black,
              secondary: secondaryColor,
            ),
        textTheme: myTextTheme,
        appBarTheme: const AppBarTheme(
            elevation: 2,
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
            color: Colors.amber),
      ),
      initialRoute: RestaurantListScreen.routeName,
      routes: {
        RestaurantListScreen.routeName: (_) => const RestaurantListScreen(),
        RestaurantDetailScreen.routeName: (context) => RestaurantDetailScreen(
            restaurant:
                ModalRoute.of(context)!.settings.arguments as Restaurant),
        RestaurantSearchScreen.routeName: (_) => const RestaurantSearchScreen(),
      },
    );
  }
}
