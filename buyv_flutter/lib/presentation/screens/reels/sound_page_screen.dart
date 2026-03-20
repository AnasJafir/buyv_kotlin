import 'package:flutter/material.dart';

class SoundPageScreen extends StatelessWidget {
  final String videoUrl;
  const SoundPageScreen({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound')),
      body: const Center(child: Text('Sound Page — Coming Soon')),
    );
  }
}
