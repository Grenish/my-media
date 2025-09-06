import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.25),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The main content of the card is tappable.
          InkWell(
            onTap: () {
              // Handle tap to navigate to post details.
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- CARD HEADER ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(post.avatarUrl),
                        backgroundColor: cs.surface,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  post.userName,
                                  style: text.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  LucideIcons.badgeCheck,
                                  size: 18,
                                  color: cs.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${post.handle} · ${post.time}',
                              style: text.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.moreHorizontal),
                        tooltip: 'More options',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    post.content,
                    style: text.bodyLarge?.copyWith(height: 1.4),
                  ),

                  if (post.imageUrl != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          post.imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : Container(
                                    color: cs.surfaceContainer,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, thickness: 0.5),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PostActionButton(
                  icon: LucideIcons.messageCircle,
                  label: '${post.comments}',
                  onTap: () {},
                ),
                _PostActionButton(
                  icon: LucideIcons.repeat2,
                  label: '${post.shares}',
                  onTap: () {},
                ),
                _PostActionButton(
                  icon: LucideIcons.heart,
                  label: '${post.likes}',
                  onTap: () {},
                  activeColor: cs.error,
                ),
                IconButton(
                  icon: const Icon(LucideIcons.forward),
                  onPressed: () {},
                  tooltip: 'Share',
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostActionButton extends StatefulWidget {
  const _PostActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.activeColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? activeColor;

  @override
  State<_PostActionButton> createState() => _PostActionButtonState();
}

class _PostActionButtonState extends State<_PostActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final hoverColor = widget.activeColor ?? cs.primary;
    final defaultColor = cs.onSurfaceVariant;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20.0,
                color: _isHovered ? hoverColor : defaultColor,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: text.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? hoverColor : defaultColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
