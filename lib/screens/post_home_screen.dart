import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/post_cards.dart';

class PostHomeScreen extends StatefulWidget {
  const PostHomeScreen({super.key});

  @override
  State<PostHomeScreen> createState() => _PostHomeScreenState();
}

class _PostHomeScreenState extends State<PostHomeScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
  if (_posts.isEmpty) {
    setState(() {
      _isLoading = true;
      _error = null;
    });
  }

  try {
    // Fetch posts
    final postUrl = Uri.parse("https://dummyjson.com/posts?limit=10");
    final postRes = await http.get(postUrl);

    if (!mounted) return;

    if (postRes.statusCode == 200) {
      final postData = jsonDecode(postRes.body);
      final postsList = postData["posts"] as List;

      // Fetch users to map userId -> user data
      final userUrl = Uri.parse("https://dummyjson.com/users?limit=100");
      final userRes = await http.get(userUrl);
      final userMap = <int, Map<String, dynamic>>{};

      if (userRes.statusCode == 200) {
        final users = jsonDecode(userRes.body)["users"] as List;
        for (var user in users) {
          userMap[user["id"]] = user;
        }
      }

      final posts = postsList.map((json) {
        final id = json["id"];
        final userId = json["userId"];
        final reactions = json["reactions"] as Map<String, dynamic>? ?? {};

        final user = userMap[userId];
        final userName = user != null
            ? "${user["firstName"]} ${user["lastName"]}"
            : "User $userId";
        final handle = user != null ? "@${user["username"]}" : "@user$userId";
        final avatarUrl = user?["image"] ?? "https://i.pravatar.cc/150?img=$userId";

        return Post(
          userName: userName,
          handle: handle,
          avatarUrl: avatarUrl,
          time: "${id}h",
          content: json["body"] ?? "",
          imageUrl: id % 2 == 0
              ? "https://picsum.photos/seed/post$id/900/500"
              : null,
          comments: reactions["dislikes"] ?? 0,
          likes: reactions["likes"] ?? 0,
          shares: ((reactions["likes"] ?? 0) / 5).round(),
        );
      }).toList();

      setState(() {
        _posts = posts.cast<Post>();
      });
    } else {
      setState(() {
        _error = "Failed to load posts. Please try again.";
      });
    }
  } catch (e) {
    debugPrint("Error fetching posts: $e");
    if (mounted) {
      setState(() {
        _error = "An unexpected error occurred. Please try again.";
      });
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchPosts,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // Show skeleton loader on initial load
    if (_isLoading && _posts.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => const _PostCardSkeleton(),
      );
    }

    // Show error message if something went wrong
    if (_error != null) {
      return _buildErrorView();
    }

    // Show message if there are no posts
    if (_posts.isEmpty) {
      return const Center(child: Text("No posts available."));
    }

    // Display the list of posts
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      itemCount: _posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        // Simple fade-in animation for each card
        return _FadeInAnimation(
          child: PostCard(post: _posts[i]),
        );
      },
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchPosts,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple fade-in animation widget for list items.
class _FadeInAnimation extends StatefulWidget {
  const _FadeInAnimation({required this.child});
  final Widget child;

  @override
  State<_FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<_FadeInAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: widget.child,
    );
  }
}

/// A skeleton loader that mimics the PostCard layout for a better UX.
class _PostCardSkeleton extends StatelessWidget {
  const _PostCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final baseColor = cs.surfaceContainer;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: cs.outline.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 22, backgroundColor: baseColor),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 16, color: baseColor),
                  const SizedBox(height: 6),
                  Container(width: 80, height: 12, color: baseColor),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(width: double.infinity, height: 14, color: baseColor),
          const SizedBox(height: 6),
          Container(width: double.infinity, height: 14, color: baseColor),
          const SizedBox(height: 6),
          Container(width: 200, height: 14, color: baseColor),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
