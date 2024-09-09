import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh/data/api/api_service.dart';
import 'package:restoguh/provider/restaurant_list_provider.dart';
import 'package:restoguh/ui/screens/restaurant_detail_screen.dart';
import 'package:restoguh/ui/screens/restaurant_search_screen.dart';
import 'package:restoguh/ui/widget/card_restaurant.dart';
import 'package:restoguh/ui/widget/loading_progress.dart';
import 'package:restoguh/ui/widget/text_message.dart';

import '../../data/model/restaurant.dart';
import '../../data/enum/result_state.dart';

class RestaurantListScreen extends StatelessWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Restoguh'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, RestaurantSearchScreen.routeName);
              },
            ),
          ],
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return Consumer<RestaurantListProvider>(
      builder: (_, provider, __) {
        switch (provider.state) {
          case ResultState.loading:
            return const LoadingProgress();
          case ResultState.hasData:
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: provider.result.count,
              itemBuilder: (_, index) {
                final restaurant = provider.result.restaurants[index];
                return CardRestaurant(restaurant: restaurant);
              },
            );
          case ResultState.noData:
            return const TextMessage(
              image: 'assets/images/no-data.png',
              message: 'Data Kosong',
            );
          case ResultState.error:
            return TextMessage(
              image: 'assets/images/no-internet.png',
              message: 'Koneksi Terputus',
              onPressed: () => provider.fetchAllRestaurant(),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
