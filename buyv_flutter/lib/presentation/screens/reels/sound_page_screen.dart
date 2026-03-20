import 'package:flutter/material.dart';

import '../../../data/datasources/remote/sound_remote_data_source.dart';
import '../../../data/models/post_models.dart';

class SoundPageScreen extends StatefulWidget {
  final String videoUrl;
  const SoundPageScreen({super.key, required this.videoUrl});

  @override
  State<SoundPageScreen> createState() => _SoundPageScreenState();
}

class _SoundPageScreenState extends State<SoundPageScreen> {
  late Future<List<SoundModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<SoundModel>> _load() {
    final dataSource = SoundRemoteDataSource();
    final query = widget.videoUrl.trim();
    if (query.isNotEmpty) {
      return dataSource.getSounds(search: query, limit: 30);
    }
    return dataSource.getTrendingSounds(limit: 30);
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound')),
      body: FutureBuilder<List<SoundModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Chargement impossible: ${snapshot.error}'));
          }

          final sounds = snapshot.data ?? const <SoundModel>[];
          if (sounds.isEmpty) {
            return const Center(child: Text('Aucun son disponible.'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: sounds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final sound = sounds[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: sound.coverImageUrl?.isNotEmpty == true
                          ? NetworkImage(sound.coverImageUrl!)
                          : null,
                      child: sound.coverImageUrl?.isNotEmpty == true
                          ? null
                          : const Icon(Icons.music_note_outlined),
                    ),
                    title: Text(sound.title),
                    subtitle: Text('${sound.artist} • ${sound.usageCount} utilisations'),
                    trailing: TextButton(
                      onPressed: () async {
                        try {
                          await SoundRemoteDataSource().incrementUsage(sound.uid);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Son "${sound.title}" selectionne.')),
                            );
                          }
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Action impossible: $error')),
                            );
                          }
                        }
                      },
                      child: const Text('Utiliser'),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
