import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const Color _cyan = Color(0xFF22D3EE);
  static const Color _purple = Color(0xFF8B5CF6);

  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _notifications = [
    {'type': 'general', 'time': 'now', 'read': false},
    {'type': 'bus', 'time': 'today', 'read': false},
    {'type': 'train', 'time': 'yesterday', 'read': true},
    {'type': 'location', 'time': 'twoDays', 'read': true},
    {'type': 'favorite', 'time': 'threeDays', 'read': true},
  ];

  int get _unreadCount =>
      _notifications.where((item) => item['read'] == false).length;

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'unread') {
      return _notifications.where((item) => item['read'] == false).toList();
    }
    return _notifications;
  }

  String _getTitle(AppLocalizations l10n, String type) {
    switch (type) {
      case 'bus':
        return l10n.notificationBusTitle;
      case 'train':
        return l10n.notificationTrainTitle;
      case 'location':
        return l10n.notificationNearbyTitle;
      case 'favorite':
        return l10n.notificationFavoritesTitle;
      default:
        return l10n.notificationWelcomeTitle;
    }
  }

  String _getMessage(AppLocalizations l10n, String type) {
    switch (type) {
      case 'bus':
        return l10n.notificationBusMessage;
      case 'train':
        return l10n.notificationTrainMessage;
      case 'location':
        return l10n.notificationNearbyMessage;
      case 'favorite':
        return l10n.notificationFavoritesMessage;
      default:
        return l10n.notificationWelcomeMessage;
    }
  }

  String _getTime(AppLocalizations l10n, String time) {
    switch (time) {
      case 'today':
        return l10n.notificationTimeToday;
      case 'yesterday':
        return l10n.notificationTimeYesterday;
      case 'twoDays':
        return l10n.notificationTimeTwoDaysAgo;
      case 'threeDays':
        return l10n.notificationTimeThreeDaysAgo;
      default:
        return l10n.notificationTimeJustNow;
    }
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

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final muted = colors.onSurface.withValues(alpha: 0.65);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext)!;
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
                      color: muted.withValues(alpha: 0.5),
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
                  _getTitle(l10n, type),
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _getMessage(l10n, type),
                  style: TextStyle(
                    color: muted,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  _getTime(l10n, notification['time'] as String),
                  style: const TextStyle(color: _cyan, fontSize: 12),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _cyan,
                      foregroundColor: colors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      l10n.notificationGotIt,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      for (final notification in _notifications) {
        notification['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.notificationAllMarkedRead),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifications = _filteredNotifications;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final muted = colors.onSurface.withValues(alpha: 0.65);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        title: Text(
          l10n.notifications,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                l10n.notificationReadAll,
                style: const TextStyle(
                  color: _cyan,
                  fontWeight: FontWeight.w600,
                ),
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
                  gradient: LinearGradient(
                    colors: isDark
                        ? const [Color(0xFF18344A), Color(0xFF28234B)]
                        : [colors.primaryContainer, colors.secondaryContainer],
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
                          Text(
                            l10n.notificationStayUpdated,
                            style: TextStyle(
                              color: isDark ? Colors.white : colors.onPrimaryContainer,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _unreadCount == 0
                                ? l10n.notificationAllCaughtUp
                                : '${l10n.notificationUnreadCountLabel} '
                                      '$_unreadCount',
                            style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : colors.onPrimaryContainer.withValues(alpha: 0.75), fontSize: 13),
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
                  Expanded(
                    child: Text(
                      l10n.notificationYourNotifications,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${notifications.length} ${l10n.notificationItemsLabel}',
                    style: TextStyle(color: muted, fontSize: 12),
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
                    label: l10n.all,
                    selected: _selectedFilter == 'all',
                    onTap: () => setState(() => _selectedFilter = 'all'),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: l10n.notificationUnreadFilter,
                    selected: _selectedFilter == 'unread',
                    onTap: () => setState(() => _selectedFilter = 'unread'),
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
                              color: muted.withValues(alpha: 0.65),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              l10n.notificationAllCaughtUp,
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.notificationNoUnread,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: muted),
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
                          color: isRead
                              ? colors.surfaceContainer
                              : (isDark ? const Color(0xFF1C3046) : colors.primaryContainer),
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
                                      ? colors.outlineVariant
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
                                                _getTitle(l10n, type),
                                                style: TextStyle(
                                                  color: colors.onSurface,
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
                                          _getMessage(l10n, type),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: muted,
                                            fontSize: 12,
                                            height: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          _getTime(
                                            l10n,
                                            notification['time'] as String,
                                          ),
                                          style: const TextStyle(
                                            color: _cyan,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: muted,
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
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _NotificationScreenState._cyan : colors.surfaceContainer,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? _NotificationScreenState._cyan : colors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? colors.surface : colors.onSurface.withValues(alpha: isDark ? 0.75 : 0.8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
