import 'dart:io';

import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:restoguh/common/navigation.dart';

import 'package:restoguh/data/api/api_service.dart';
import 'package:restoguh/data/db/database_helper.dart';
import 'package:restoguh/data/preferences/preferences_helper.dart';
import 'package:restoguh/helpers/background_service.dart';
import 'package:restoguh/helpers/notification_helper.dart';
import 'package:restoguh/provider/database_provider.dart';
import 'package:restoguh/provider/preferences_provider.dart';
import 'package:restoguh/provider/restaurant_list_provider.dart';
import 'package:restoguh/provider/restaurant_search_provider.dart';
import 'package:restoguh/provider/scheduling_provider.dart';
import 'package:restoguh/ui/screens/home_screen.dart';
import 'package:restoguh/ui/screens/restaurant_list_screen.dart';
import 'package:restoguh/ui/screens/restaurant_detail_screen.dart';
import 'package:restoguh/ui/screens/restaurant_search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/model/restaurant_list_model.dart';
import 'common/styles.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantListProvider(
            apiService: ApiService(http.Client()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantSearchProvider(
            apiService: ApiService(http.Client()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        )
      ],
      child: MaterialApp(
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
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
              color: Colors.amber),
        ),
        navigatorKey: navigatorKey,
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (_) => const HomeScreen(),
          RestaurantListScreen.routeName: (_) => const RestaurantListScreen(),
          RestaurantDetailScreen.routeName: (context) => RestaurantDetailScreen(
              restaurant:
                  ModalRoute.of(context)!.settings.arguments as Restaurant),
          RestaurantSearchScreen.routeName: (_) =>
              const RestaurantSearchScreen(),
        },
      ),
    );
  }
}
