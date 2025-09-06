import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Discover'),
            pinned: true,
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SearchBar(),
                  SizedBox(height: 24),
                  _TrendingSection(),
                  SizedBox(height: 24),
                  _GridHeader(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: _PhotoGrid(),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search posts, photos, and more...',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class _TrendingSection extends StatelessWidget {
  const _TrendingSection();

  @override
  Widget build(BuildContext context) {
    final trendingTopics = [
      '#FlutterDev',
      '#UIUX',
      '#TechNews',
      '#Material3',
      '#Dart',
      '#MobileApp',
      '#CreativeCoding',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending Now',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: trendingTopics.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              // ActionChip is more appropriate for interactive tags.
              return ActionChip(
                onPressed: () {
                  // Handle chip tap action
                },
                label: Text(trendingTopics[index]),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
                backgroundColor: Theme.of(context).colorScheme.surface,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A simple header for the photo grid section.
class _GridHeader extends StatelessWidget {
  const _GridHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Popular Photos',
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// A SliverGrid of photos, similar to Instagram's discover page.
class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid();

  @override
  Widget build(BuildContext context) {
    final imageIds = List.generate(20, (index) => index + 150);

    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8, // Adjust aspect ratio for a better look
      ),
      itemCount: imageIds.length,
      itemBuilder: (context, index) {
        final isTall = index % 4 == 1 || index % 4 == 2;
        return Material(
          borderRadius: BorderRadius.circular(12.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // Handle image tap action
            },
            child: Image.network(
              'https://picsum.photos/seed/${imageIds[index]}/400/${isTall ? 600 : 400}',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : Container(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
