import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/datasources/remote/post_remote_data_source.dart';
import '../../../data/models/post_models.dart';

class SearchReelsScreen extends StatefulWidget {
  const SearchReelsScreen({super.key});

  @override
  State<SearchReelsScreen> createState() => _SearchReelsScreenState();
}

class _SearchReelsScreenState extends State<SearchReelsScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';
  Future<List<PostModel>>? _future;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _runSearch() {
    final nextQuery = _queryController.text.trim();
    setState(() {
      _query = nextQuery;
      _future = nextQuery.isEmpty
          ? null
          : PostRemoteDataSource().searchPosts(query: nextQuery, type: 'reel', limit: 40);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche reels')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _queryController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _runSearch(),
              decoration: InputDecoration(
                hintText: 'Rechercher une caption ou un auteur...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _runSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: _future == null
                ? const Center(child: Text('Lance une recherche pour afficher des reels.'))
                : FutureBuilder<List<PostModel>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Recherche impossible: ${snapshot.error}'));
                      }

                      final posts = snapshot.data ?? const <PostModel>[];
                      if (posts.isEmpty) {
                        return Center(child: Text('Aucun resultat pour "$_query".'));
                      }

                      return ListView.separated(
                        itemCount: posts.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return ListTile(
                            leading: const Icon(Icons.play_circle_outline),
                            title: Text(
                              post.caption?.trim().isNotEmpty == true
                                  ? post.caption!.trim()
                                  : '(Sans caption)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text('@${post.username}'),
                            trailing: Text('${post.likesCount} likes'),
                            onTap: () => context.push('/social/user/${post.userId}'),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

