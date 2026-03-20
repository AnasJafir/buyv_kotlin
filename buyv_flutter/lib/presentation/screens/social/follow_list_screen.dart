import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/datasources/remote/social_remote_data_source.dart';
import '../../providers/social_provider.dart';
import '../../router/app_router.dart';

class FollowListScreen extends ConsumerStatefulWidget {
  final String userId;
  final int startTab;
  const FollowListScreen({super.key, required this.userId, this.startTab = 0});

  @override
  ConsumerState<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends ConsumerState<FollowListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.startTab.clamp(0, 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Followers / Following')),
      body: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: 'Followers'),
              Tab(text: 'Following'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _UserListTab(asyncUsers: ref.watch(followersProvider(widget.userId))),
                _UserListTab(asyncUsers: ref.watch(followingProvider(widget.userId))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserListTab extends StatelessWidget {
  const _UserListTab({required this.asyncUsers});

  final AsyncValue<List<SocialListUser>> asyncUsers;

  @override
  Widget build(BuildContext context) {
    return asyncUsers.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(child: Text('Aucun utilisateur.'));
        }
        return ListView.separated(
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.profileImageUrl?.isNotEmpty == true
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                child: user.profileImageUrl?.isNotEmpty == true
                    ? null
                    : const Icon(Icons.person_outline),
              ),
              title: Text(user.displayName),
              subtitle: Text('@${user.username}'),
              trailing: user.isVerified
                  ? const Icon(Icons.verified, color: Colors.blue)
                  : null,
              onTap: () => context.push(
                AppRoutes.userProfile.replaceFirst(':userId', user.id),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Chargement impossible: $error')),
    );
  }
}
