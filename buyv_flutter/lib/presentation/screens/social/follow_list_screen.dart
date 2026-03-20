import 'package:flutter/material.dart';

class FollowListScreen extends StatelessWidget {
  final String userId;
  final int startTab;
  const FollowListScreen({super.key, required this.userId, this.startTab = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Followers / Following')),
      body: const Center(child: Text('Follow List — Coming Soon')),
    );
  }
}
