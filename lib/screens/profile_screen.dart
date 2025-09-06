import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UserProfile {
  final String name;
  final String handle;
  final String avatarUrl;
  final String coverUrl;
  final String bio;
  final int postCount;
  final int followersCount;
  final int followingCount;
  final List<String> posts;

  const UserProfile({
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.coverUrl,
    required this.bio,
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
    required this.posts,
  });
}

class Post {
  final String userName;
  final String handle;
  final String avatarUrl;
  final String time;
  final String content;
  final String? imageUrl;
  final int comments;
  final int likes;
  final int shares;

  const Post({
    required this.userName,
    required this.handle,
    required this.avatarUrl,
    required this.time,
    required this.content,
    this.imageUrl,
    this.comments = 0,
    this.likes = 0,
    this.shares = 0,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _user = UserProfile(
    name: 'John Doe',
    handle: '@johndoe',
    avatarUrl:
        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
    coverUrl:
        'https://images.unsplash.com/photo-1494253109108-2e30c049369b?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGNvdmVyfGVufDB8fDB8fHww',
    bio:
        'Digital Nomad | Photographer 📸\nExploring the world one snapshot at a time.',
    postCount: 153,
    followersCount: 5420,
    followingCount: 312,
    posts: List.generate(18, (i) => 'https://picsum.photos/seed/${i + 70}/500'),
  );

  final _mockPosts = <Post>[
    Post(
      userName: 'Jane Smith',
      handle: '@janesmith',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      time: '3h',
      content: 'Loving the new design updates on the app! So clean. ✨',
      imageUrl: 'https://picsum.photos/seed/post1/900/500',
      comments: 32,
      likes: 451,
      shares: 22,
    ),
    Post(
      userName: 'Alex Johnson',
      handle: '@alexj',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      time: '5h',
      content: 'The new profile screen looks amazing. Great work by the team!',
      comments: 12,
      likes: 210,
      shares: 10,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 240.0,
                floating: false,
                pinned: true,
                stretch: true,
                elevation: 0,
                backgroundColor: cs.surface,
                actions: [
                  IconButton(
                    icon: const Icon(LucideIcons.moreVertical),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: _CoverImage(url: _user.coverUrl),
                ),
              ),
              SliverToBoxAdapter(child: _ProfileHeader(user: _user)),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(icon: Icon(LucideIcons.layoutGrid)),
                      Tab(icon: Icon(LucideIcons.list)),
                      Tab(icon: Icon(LucideIcons.userSquare)),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _PostGrid(posts: _user.posts),
              _PostsTimeline(posts: _mockPosts),
              const _TaggedPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}

/* =====================================
   Cover image with proper loading/error
   ===================================== */

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Smooth loading + error handling to avoid layout jumps
        Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(color: cs.surfaceContainerHighest);
          },
          errorBuilder: (_, __, ___) =>
              Container(color: cs.surfaceVariant.withOpacity(0.6)),
        ),
        // Gentle fade at bottom to improve text/overlay readability
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.35), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});
  final UserProfile user;

  static const double _avatarRadius = 44;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Stack(
      clipBehavior: Clip.none, // allow the avatar to overlap the cover
      children: [
        // Body content with enough top padding for the overlapping avatar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, _avatarRadius + 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Actions (Follow / Message)
              Align(alignment: Alignment.topRight, child: _ProfileActions()),
              const SizedBox(height: 12),
              Text(
                user.name,
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                user.handle,
                style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              Text(user.bio, style: text.bodyMedium),
              const SizedBox(height: 14),
              _ProfileStats(
                postCount: user.postCount,
                followersCount: user.followersCount,
                followingCount: user.followingCount,
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: _avatarRadius,
              backgroundColor: cs.surfaceContainerHigh,
              foregroundImage: NetworkImage(user.avatarUrl),
              onForegroundImageError: (_, __) {},
              child: Icon(
                LucideIcons.user,
                size: 28,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilledButton.tonal(onPressed: () {}, child: const Text('Follow')),
        const SizedBox(width: 8),
        FilledButton(onPressed: () {}, child: const Text('Message')),
      ],
    );
  }
}

/* =========================
   Stats + Posts + Timeline
   ========================= */

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
  });

  final int postCount;
  final int followersCount;
  final int followingCount;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        _StatItem(label: 'Posts', value: '$postCount'),
        const SizedBox(width: 24),
        _StatItem(
          label: 'Followers',
          value: '${(followersCount / 1000).toStringAsFixed(1)}k',
        ),
        const SizedBox(width: 24),
        _StatItem(label: 'Following', value: '$followingCount'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return RichText(
      text: TextSpan(
        style: text.bodyMedium,
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: label,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PostGrid extends StatelessWidget {
  const _PostGrid({required this.posts});
  final List<String> posts;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Image.network(
            posts[index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              return progress == null
                  ? child
                  : Container(color: cs.surfaceContainerHighest);
            },
            errorBuilder: (_, __, ___) =>
                Container(color: cs.surfaceVariant.withOpacity(0.6)),
          ),
        );
      },
    );
  }
}

class _PostsTimeline extends StatelessWidget {
  const _PostsTimeline({required this.posts});
  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _SimplePostCard(post: posts[index]);
      },
    );
  }
}

class _SimplePostCard extends StatelessWidget {
  const _SimplePostCard({required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: cs.outline.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: cs.surfaceContainerHigh,
                  foregroundImage: NetworkImage(post.avatarUrl),
                  onForegroundImageError: (_, __) {},
                  child: Icon(
                    LucideIcons.user,
                    size: 18,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${post.handle} · ${post.time}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.moreHorizontal),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: cs.surfaceVariant.withOpacity(0.6),
                    height: 160,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TaggedPlaceholder extends StatelessWidget {
  const _TaggedPlaceholder();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.userSquare,
            size: 48,
            color: cs.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tagged posts yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'When people tag you in photos, they will appear here.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverTabBarDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
