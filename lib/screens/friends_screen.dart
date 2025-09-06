import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';

class Friend {
  final String name;
  final String handle;
  final String avatarUrl;

  const Friend({
    required this.name,
    required this.handle,
    required this.avatarUrl,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: '${json['firstName']} ${json['lastName']}',
      handle: '@${json['username']}',
      avatarUrl: json['image'] ?? 'https://i.pravatar.cc/150',
    );
  }
}

class FriendRequest {
  final String name;
  final String handle;
  final String avatarUrl;
  final String time;

  const FriendRequest({
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.time,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json, int index) {
    return FriendRequest(
      name: '${json['firstName']} ${json['lastName']}',
      handle: '@${json['username']}',
      avatarUrl: json['image'] ?? 'https://i.pravatar.cc/150',
      time: '${index + 1}w',
    );
  }
}

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List<Friend> _friends = [];
  List<FriendRequest> _friendRequests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/users?limit=10'));
      final data = jsonDecode(response.body);

      final users = (data['users'] as List);

      setState(() {
        _friends = users.take(7).map((u) => Friend.fromJson(u)).toList();
        _friendRequests = users.skip(7).mapIndexed((i, u) => FriendRequest.fromJson(u, i)).toList();
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error fetching users: $e');
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text('Friends'),
              pinned: true,
              floating: true,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.userPlus),
                  onPressed: () {},
                  tooltip: 'Add Friend',
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('My Friends'),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Text(
                            '${_friends.length}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Requests'),
                        if (_friendRequests.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              '${_friendRequests.length}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _FriendsList(friends: _friends),
            _FriendRequestsList(requests: _friendRequests),
          ],
        ),
      ),
    );
  }
}

extension _MapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) f) {
    var index = 0;
    return map((e) => f(index++, e));
  }
}


class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.surfaceVariant),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class _FriendsList extends StatelessWidget {
  const _FriendsList({required this.friends});
  final List<Friend> friends;

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return const _EmptyState(
        icon: LucideIcons.users,
        message: 'You have no friends yet.\nFind new people to connect with!',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return _FriendListItem(friend: friend);
      },
    );
  }
}

class _FriendListItem extends StatelessWidget {
  const _FriendListItem({required this.friend});
  final Friend friend;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(friend.avatarUrl),
      ),
      title: Text(friend.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(friend.handle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(LucideIcons.messageSquare),
            onPressed: () {},
            tooltip: 'Message',
          ),
          IconButton(
            icon: const Icon(LucideIcons.moreVertical),
            onPressed: () {},
            tooltip: 'More',
          ),
        ],
      ),
    );
  }
}

class _FriendRequestsList extends StatelessWidget {
  const _FriendRequestsList({required this.requests});
  final List<FriendRequest> requests;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const _EmptyState(
        icon: LucideIcons.userPlus,
        message: 'No new friend requests.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _FriendRequestItem(request: request),
        );
      },
    );
  }
}

class _FriendRequestItem extends StatelessWidget {
  const _FriendRequestItem({required this.request});
  final FriendRequest request;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outline.withOpacity(0.5))
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(request.avatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.name, style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(
                        request.handle,
                        style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  request.time,
                  style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.check),
                    label: const Text('Confirm'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.x),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.error,
                      side: BorderSide(color: cs.error.withOpacity(0.5))
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

