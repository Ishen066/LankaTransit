import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const Color _bg = Color(0xFF0B1220);
  static const Color _panel = Color(0xFF172337);
  static const Color _cyan = Color(0xFF22D3EE);
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _text = Color(0xFFF1F5F9);
  static const Color _muted = Color(0xFF94A3B8);

  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Welcome to LankaTransit!',
      'message':
          'Thank you for using LankaTransit. Explore bus and train routes '
          'and plan your next journey around Sri Lanka.',
      'type': 'general',
      'time': 'Just now',
      'read': false,
    },
    {
      'title': 'Bus Routes',
      'message':
          'Explore available bus route information and check your preferred '
          'destination before starting your journey.',
      'type': 'bus',
      'time': 'Today',
      'read': false,
    },
    {
      'title': 'Train Journey',
      'message':
          'Visit the Train Routes section to explore train journey '
          'information for your next trip.',
      'type': 'train',
      'time': 'Yesterday',
      'read': true,
    },
    {
      'title': 'Nearby Transport',
      'message':
          'Use Nearby Transport to explore transport options around '
          'your current location.',
      'type': 'location',
      'time': '2 days ago',
      'read': true,
    },
    {
      'title': 'Save Your Favourite Routes',
      'message':
          'Tap the heart icon on a route to add it to your favourite routes '
          'and find it more easily later.',
      'type': 'favorite',
      'time': '3 days ago',
      'read': true,
    },
  ];

  int get _unreadCount =>
      _notifications.where((item) => item['read'] == false).length;

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'Unread') {
      return _notifications.where((item) => item['read'] == false).toList();
    }
    return _notifications;
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'bus':
        return Icons.directions_bus_rounded;
      case 'train':
        return Icons.train_rounded;
      case 'location':
        return Icons.location_on_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'bus':
        return _cyan;
      case 'train':
        return _purple;
      case 'location':
        return Colors.orangeAccent;
      case 'favorite':
        return Colors.pinkAccent;
      default:
        return _cyan;
    }
  }

  void _openNotification(Map<String, dynamic> notification) {
    setState(() {
      notification['read'] = true;
    });

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _panel,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetContext) {
        final type = notification['type'] as String;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _muted.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _getIconColor(type).withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getIcon(type),
                    color: _getIconColor(type),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  notification['title'] as String,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  notification['message'] as String,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  notification['time'] as String,
                  style: const TextStyle(color: _cyan, fontSize: 12),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _cyan,
                      foregroundColor: _bg,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _filteredNotifications;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: _text,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Read all',
                style: TextStyle(color: _cyan, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF18344A), Color(0xFF28234B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: _cyan,
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Stay updated!',
                            style: TextStyle(
                              color: _text,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _unreadCount == 0
                                ? 'You are all caught up.'
                                : 'You have $_unreadCount unread '
                                      '${_unreadCount == 1 ? 'notification' : 'notifications'}.',
                            style: const TextStyle(color: _muted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your notifications',
                      style: TextStyle(
                        color: _text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${notifications.length} items',
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _selectedFilter == 'All',
                    onTap: () => setState(() => _selectedFilter = 'All'),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: 'Unread',
                    selected: _selectedFilter == 'Unread',
                    onTap: () => setState(() => _selectedFilter = 'Unread'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              size: 65,
                              color: _muted.withValues(alpha: 0.65),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'You are all caught up!',
                              style: TextStyle(
                                color: _text,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'There are no unread notifications.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: _muted),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final type = notification['type'] as String;
                        final isRead = notification['read'] as bool;

                        return Material(
                          color: isRead ? _panel : const Color(0xFF1C3046),
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            onTap: () => _openNotification(notification),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isRead
                                      ? const Color(0xFF29384D)
                                      : _cyan.withValues(alpha: 0.45),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _getIconColor(type)
                                          .withValues(alpha: 0.13),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      _getIcon(type),
                                      color: _getIconColor(type),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 13),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notification['title'] as String,
                                                style: TextStyle(
                                                  color: _text,
                                                  fontSize: 14,
                                                  fontWeight: isRead
                                                      ? FontWeight.w500
                                                      : FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            if (!isRead) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: const EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: _cyan,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          notification['message'] as String,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: _muted,
                                            fontSize: 12,
                                            height: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          notification['time'] as String,
                                          style: const TextStyle(
                                            color: _cyan,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: _muted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF22D3EE) : const Color(0xFF172337),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? const Color(0xFF22D3EE) : const Color(0xFF29384D),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF0B1220) : const Color(0xFF94A3B8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
