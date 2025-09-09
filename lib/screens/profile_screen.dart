import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/* ============================
   Models
   ============================ */

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

  // Extras for richer UX
  final bool verified;
  final String? location;
  final String? website;
  final DateTime? joinedAt;
  final List<String> mutualAvatars;

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
    this.verified = false,
    this.location,
    this.website,
    this.joinedAt,
    this.mutualAvatars = const [],
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
  final int reposts;
  final bool pinned;

  const Post({
    required this.userName,
    required this.handle,
    required this.avatarUrl,
    required this.time,
    required this.content,
    this.imageUrl,
    this.comments = 0,
    this.likes = 0,
    this.reposts = 0,
    this.pinned = false,
  });
}

/* ============================
   Screen
   ============================ */

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isFollowing = false;
  bool _bioExpanded = false;

  final _user = UserProfile(
    name: 'John Doe',
    handle: '@johndoe',
    avatarUrl:
        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
    coverUrl:
        'https://images.unsplash.com/photo-1494253109108-2e30c049369b?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGNvdmVyfGVufDB8fDB8fHww',
    bio:
        'Digital Nomad • Photographer 📸\nExploring the world one snapshot at a time.',
    postCount: 153,
    followersCount: 5420,
    followingCount: 312,
    posts: List.generate(18, (i) => 'https://picsum.photos/seed/${i + 70}/500'),
    verified: true,
    location: 'Lisbon, Portugal',
    website: 'johndoe.me',
    joinedAt: DateTime(2020, 5, 12),
    mutualAvatars: const [
      'https://i.pravatar.cc/150?img=8',
      'https://i.pravatar.cc/150?img=5',
      'https://i.pravatar.cc/150?img=12',
      'https://i.pravatar.cc/150?img=25',
    ],
  );

  late final List<Post> _mockPosts = [
    Post(
      userName: 'John Doe',
      handle: '@johndoe',
      avatarUrl: _user.avatarUrl,
      time: 'Pinned',
      content:
          'Pinned: Heres my favorite sunset from last week travel photography',
      imageUrl: 'https://picsum.photos/seed/pinned1/1200/700',
      comments: 68,
      likes: 1250,
      reposts: 140,
      pinned: true,
    ),
    Post(
      userName: 'Jane Smith',
      handle: '@janesmith',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      time: '3h',
      content: 'Loving the new design updates on the app! So clean. ✨',
      imageUrl: 'https://picsum.photos/seed/post1/900/500',
      comments: 32,
      likes: 451,
      reposts: 22,
    ),
    Post(
      userName: 'Alex Johnson',
      handle: '@alexj',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      time: '5h',
      content: 'The new profile screen looks amazing. Great work by the team!',
      comments: 12,
      likes: 210,
      reposts: 10,
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
                expandedHeight: 280,
                pinned: true,
                stretch: true,
                elevation: 0,
                backgroundColor: cs.surface,
                actions: [
                  IconButton(
                    tooltip: 'More',
                    icon: const Icon(LucideIcons.moreVertical),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: _CoverImageWithFrost(url: _user.coverUrl),
                ),
              ),
              SliverToBoxAdapter(
                child: _ProfileHeader(
                  user: _user,
                  isFollowing: _isFollowing,
                  bioExpanded: _bioExpanded,
                  onToggleFollow: () =>
                      setState(() => _isFollowing = !_isFollowing),
                  onToggleBio: () =>
                      setState(() => _bioExpanded = !_bioExpanded),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    labelColor: cs.primary,
                    unselectedLabelColor: cs.onSurfaceVariant,
                    indicatorColor: cs.primary,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(icon: Icon(LucideIcons.list), text: 'Posts'),
                      Tab(icon: Icon(LucideIcons.layoutGrid), text: 'Grid'),
                      Tab(icon: Icon(LucideIcons.userSquare), text: 'Tagged'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _PostsTimeline(posts: _mockPosts),
              _PostGrid(posts: _user.posts),
              const _TaggedPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================
   Cover
   ========================= */

class _CoverImageWithFrost extends StatelessWidget {
  const _CoverImageWithFrost({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
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
        // Bottom gradient for readability
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

/* =========================
   Header
   ========================= */

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.isFollowing,
    required this.bioExpanded,
    required this.onToggleFollow,
    required this.onToggleBio,
  });

  final UserProfile user;
  final bool isFollowing;
  final bool bioExpanded;
  final VoidCallback onToggleFollow;
  final VoidCallback onToggleBio;

  static const double _avatarRadius = 44;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + name + handle
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _StoryRingAvatar(imageUrl: user.avatarUrl, radius: _avatarRadius),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          user.name,
                          style: text.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (user.verified)
                          Icon(
                            LucideIcons.badgeCheck,
                            size: 18,
                            color: cs.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.handle,
                      style: text.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bio (expandable)
          GestureDetector(
            onTap: onToggleBio,
            behavior: HitTestBehavior.opaque,
            child: AnimatedCrossFade(
              crossFadeState: bioExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 180),
              firstChild: Text(
                user.bio,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text.bodyMedium,
              ),
              secondChild: Text(user.bio, style: text.bodyMedium),
            ),
          ),

          const SizedBox(height: 10),

          // Meta chips: location • website • joined
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              if (user.location != null)
                _InfoChip(icon: LucideIcons.mapPin, label: user.location!),
              if (user.website != null)
                _InfoChip(icon: LucideIcons.link, label: user.website!),
              if (user.joinedAt != null)
                _InfoChip(
                  icon: LucideIcons.calendarDays,
                  label: 'Joined ${_joined(user.joinedAt!)}',
                ),
            ],
          ),

          const SizedBox(height: 10),

          // Mutual followers (compact)
          if (user.mutualAvatars.isNotEmpty)
            Row(
              children: [
                _OverlappingAvatars(urls: user.mutualAvatars.take(3).toList()),
                const SizedBox(width: 8),
                Text(
                  'Followed by ${_firstNames(user.mutualAvatars)}',
                  style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),

          const SizedBox(height: 14),

          // Stats (tappable)
          _ProfileStats(
            postCount: user.postCount,
            followersCount: user.followersCount,
            followingCount: user.followingCount,
          ),

          const SizedBox(height: 14),

          // Actions (Follow / Message / More)
          Row(
            children: [
              Expanded(
                child: isFollowing
                    ? FilledButton.tonalIcon(
                        icon: const Icon(LucideIcons.check),
                        onPressed: onToggleFollow,
                        label: const Text('Following'),
                      )
                    : FilledButton.icon(
                        icon: const Icon(LucideIcons.userPlus),
                        onPressed: onToggleFollow,
                        label: const Text('Follow'),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(LucideIcons.messageCircle),
                  onPressed: () {},
                  label: const Text('Message'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(LucideIcons.moreHorizontal),
                tooltip: 'More',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _joined(DateTime dt) {
    // Example: May 2020
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }

  String _firstNames(List<String> urls) {
    // Pretend: use 2 sample names
    // In a real app, you’d have mutual names from API.
    if (urls.length >= 2) return 'Alex & Jane';
    if (urls.length == 1) return 'Alex';
    return 'friends';
  }
}

/* =========================
   Components
   ========================= */

class _StoryRingAvatar extends StatelessWidget {
  const _StoryRingAvatar({required this.imageUrl, this.radius = 44});
  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Subtle story ring vibe
        gradient: SweepGradient(
          colors: [
            cs.primary.withOpacity(0.9),
            cs.secondary.withOpacity(0.9),
            cs.primary.withOpacity(0.9),
          ],
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: cs.surface,
        foregroundImage: NetworkImage(imageUrl),
        onForegroundImageError: (_, __) {},
        child: Icon(LucideIcons.user, color: cs.onSurfaceVariant),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

/* =========================
   Stats
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
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Widget item(String label, int value) {
      return Expanded(
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  _compact(value),
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: text.labelMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        item('Posts', postCount),
        const SizedBox(width: 8),
        item('Followers', followersCount),
        const SizedBox(width: 8),
        item('Following', followingCount),
      ],
    );
  }
}

/* =========================
   Grid
   ========================= */

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
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
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
              // Subtle top-right overlay (e.g., gallery icon)
              Positioned(
                top: 6,
                right: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      LucideIcons.image,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/* =========================
   Timeline
   ========================= */

class _PostsTimeline extends StatelessWidget {
  const _PostsTimeline({required this.posts});
  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: posts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _PostCard(post: posts[index]);
      },
    );
  }
}

class _PostCard extends StatefulWidget {
  const _PostCard({required this.post});
  final Post post;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late int likes;
  bool liked = false;

  @override
  void initState() {
    super.initState();
    likes = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: cs.surfaceContainerHigh,
                  foregroundImage: NetworkImage(widget.post.avatarUrl),
                  onForegroundImageError: (_, __) {},
                  child: Icon(
                    LucideIcons.user,
                    size: 18,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.post.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '· ${widget.post.time}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Text(
                              widget.post.handle,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant),
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
                ),
              ],
            ),

            if (widget.post.pinned) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(LucideIcons.pin, size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    'Pinned',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 8),
            _LinkifiedText(widget.post.content),

            if (widget.post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.post.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: cs.surfaceVariant.withOpacity(0.6),
                    height: 160,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 10),
            _ActionRow(
              comments: widget.post.comments,
              reposts: widget.post.reposts,
              likes: likes,
              liked: liked,
              onToggleLike: () {
                setState(() {
                  liked = !liked;
                  likes += liked ? 1 : -1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.comments,
    required this.reposts,
    required this.likes,
    required this.liked,
    required this.onToggleLike,
  });

  final int comments;
  final int reposts;
  final int likes;
  final bool liked;
  final VoidCallback onToggleLike;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget btn(
      IconData icon,
      String label,
      VoidCallback onTap, {
      Color? color,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color ?? cs.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        btn(LucideIcons.messageCircle, _compact(comments), () {}),
        btn(LucideIcons.repeat, _compact(reposts), () {}),
        btn(
          liked ? LucideIcons.heart : LucideIcons.heart,
          _compact(likes),
          onToggleLike,
          color: liked ? cs.error : cs.onSurfaceVariant,
        ),
        btn(LucideIcons.share2, 'Share', () {}),
      ],
    );
  }
}

/* =========================
   Tagged Placeholder
   ========================= */

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

/* =========================
   Sliver TabBar Delegate
   ========================= */

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
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}

/* =========================
   Helpers
   ========================= */

class _OverlappingAvatars extends StatelessWidget {
  const _OverlappingAvatars({required this.urls, this.size = 20});
  final List<String> urls;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final children = <Widget>[];
    for (var i = 0; i < urls.length; i++) {
      children.add(
        Positioned(
          left: i * (size - 8),
          child: CircleAvatar(
            radius: size,
            backgroundColor: cs.surface,
            foregroundImage: NetworkImage(urls[i]),
            onForegroundImageError: (_, __) {},
            child: Icon(
              LucideIcons.user,
              size: size,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: urls.isEmpty ? 0 : size + (urls.length - 1) * (size - 8),
      height: size * 2,
      child: Stack(children: children),
    );
  }
}

class _LinkifiedText extends StatelessWidget {
  const _LinkifiedText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final parts = text.split(RegExp(r'(\s+)'));
    return SelectableText.rich(
      TextSpan(
        children: parts.map((word) {
          final isTag = word.startsWith('#') || word.startsWith('@');
          final isUrl = word.startsWith('http');
          if (isTag || isUrl) {
            return TextSpan(
              text: word,
              style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600),
            );
          }
          return TextSpan(text: word);
        }).toList(),
      ),
    );
  }
}

String _compact(int n) {
  if (n >= 1000000) {
    final v = n / 1000000;
    return v % 1 == 0 ? '${v.toStringAsFixed(0)}M' : '${v.toStringAsFixed(1)}M';
  }
  if (n >= 1000) {
    final v = n / 1000;
    return v % 1 == 0 ? '${v.toStringAsFixed(0)}K' : '${v.toStringAsFixed(1)}K';
  }
  return '$n';
}
