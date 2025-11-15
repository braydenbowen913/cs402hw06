import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../widgets/photo_card.dart';

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final photos = context.watch<PhotoProvider>().filteredPhotos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WindowPane'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) =>
                  context.read<PhotoProvider>().setSearchQuery(value),
            ),
          ),
        ),
      ),
      body: photos.isEmpty
          ? const Center(child: Text('No photos'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final entry = photos[index];
                return PhotoCard(
                  entry: entry,
                  onTap: () {
                    final provider = context.read<PhotoProvider>();
                    final idx = provider.photos
                        .indexWhere((element) => element.id == entry.id);
                    if (idx != -1) {
                      provider.setCurrentIndex(idx);
                    }
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<PhotoProvider>().addNewPhoto(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
