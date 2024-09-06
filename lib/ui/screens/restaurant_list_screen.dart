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
    return ChangeNotifierProvider<RestaurantListProvider>(
      create: (_) => RestaurantListProvider(apiService: ApiService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, RestaurantSearchScreen.routeName);
              },
            ),
          ],
        ),
        body: _buildList(),
      ),
    );
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

  Widget _itemList(BuildContext context, Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RestaurantDetailScreen.routeName,
          arguments: restaurant,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 100,
                width: 125,
                child: restaurant.pictureId == null
                    ? Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey[400],
                      )
                    : Image.network(
                        restaurant.pictureId!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey[400],
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey[400],
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '${restaurant.name}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.city}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: const Color(0xFF616161)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.rating}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: const Color(0xFF616161)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
