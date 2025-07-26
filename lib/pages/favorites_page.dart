import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../models/Cryptocurrency.dart';
import 'DetailsPage.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Text(
          'No favorites added yet!',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.separated(
        itemCount: favorites.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final coin = favorites[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(coin.image ?? ''),
              radius: 20,
            ),
            title: Text(coin.name ?? 'Unknown'),
            subtitle: Text(coin.symbol?.toUpperCase() ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                favoritesProvider.removeFavorite(coin);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${coin.name} removed from favorites'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsPage(id: coin.id ?? ''),
              ),
            ),
          );
        },
      ),
    );
  }
}



