import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/profile_provider.dart';
import '../../widgets/common/error_snackbar.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final action = ref.watch(profileActionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: <Widget>[
          TextButton(
            onPressed: action.isLoading
                ? null
                : () async {
                    try {
                      await ref.read(profileActionProvider.notifier).clearNotifications();
                    } catch (error) {
                      if (context.mounted) {
                        showErrorSnackbar(context, error.toString());
                      }
                    }
                  },
            child: const Text('Vider tout'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Aucune notification.'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(notificationsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                final createdAt = DateTime.tryParse(item.createdAt);
                final dateText = createdAt == null
                    ? '--'
                    : DateFormat('dd/MM/yyyy HH:mm').format(createdAt.toLocal());

                return Dismissible(
                  key: ValueKey<int>(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red.shade400,
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    try {
                      await ref.read(profileActionProvider.notifier).deleteNotification(item.id);
                    } catch (error) {
                      if (context.mounted) {
                        showErrorSnackbar(context, error.toString());
                      }
                    }
                  },
                  child: Card(
                    color: item.isRead
                        ? null
                        : Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                    child: ListTile(
                      leading: Icon(item.isRead ? Icons.notifications_none : Icons.notifications_active),
                      title: Text(item.title),
                      subtitle: Text('${item.body}\n$dateText'),
                      isThreeLine: true,
                      trailing: item.isRead
                          ? null
                          : TextButton(
                              onPressed: action.isLoading
                                  ? null
                                  : () async {
                                      try {
                                        await ref
                                            .read(profileActionProvider.notifier)
                                            .markNotificationAsRead(item.id);
                                      } catch (error) {
                                        if (context.mounted) {
                                          showErrorSnackbar(context, error.toString());
                                        }
                                      }
                                    },
                              child: const Text('Marquer lu'),
                            ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Chargement impossible: $error')),
      ),
    );
  }
}

