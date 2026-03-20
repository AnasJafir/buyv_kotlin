import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/datasources/remote/post_remote_data_source.dart';
import '../../../data/models/post_models.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<PostModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = PostRemoteDataSource().getFeed(limit: 60);
  }

  Future<void> _refresh() async {
    final next = PostRemoteDataSource().getFeed(limit: 60);
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorer les reels')),
      body: FutureBuilder<List<PostModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Chargement impossible: ${snapshot.error}'));
          }

          final reels = (snapshot.data ?? const <PostModel>[])
              .where((post) => post.type == 'reel')
              .toList(growable: false);

          if (reels.isEmpty) {
            return const Center(child: Text('Aucun reel a explorer pour le moment.'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: reels.length,
              itemBuilder: (context, index) {
                final post = reels[index];
                final image = post.thumbnailUrl ?? post.videoUrl;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => context.push('/social/user/${post.userId}'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if (image != null && image.isNotEmpty)
                          Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.black12,
                              child: const Icon(Icons.videocam_outlined),
                            ),
                          )
                        else
                          Container(
                            color: Colors.black12,
                            child: const Icon(Icons.videocam_outlined),
                          ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.65),
                                ],
                              ),
                            ),
                            child: Text(
                              post.caption?.trim().isNotEmpty == true
                                  ? post.caption!.trim()
                                  : '@${post.username}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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

