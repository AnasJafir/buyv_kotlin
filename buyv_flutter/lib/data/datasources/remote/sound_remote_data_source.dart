import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../models/post_models.dart';

class SoundRemoteDataSource {
  SoundRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.authenticated;

  final Dio _dio;

  Future<List<SoundModel>> getSounds({
    String? search,
    String? genre,
    bool? featured,
    int limit = 30,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '/api/sounds',
      queryParameters: <String, dynamic>{
        if (search != null && search.isNotEmpty) 'search': search,
        if (genre != null && genre.isNotEmpty) 'genre': genre,
        if (featured != null) 'featured': featured,
        'limit': limit,
        'offset': offset,
      },
    );

    final raw = response.data;
    if (raw is! List) {
      return const <SoundModel>[];
    }

    return raw
        .whereType<Map<String, dynamic>>()
        .map(_safeSoundFromJson)
        .toList(growable: false);
  }

  Future<List<SoundModel>> getTrendingSounds({int limit = 20}) async {
    final response = await _dio.get(
      '/api/sounds/trending',
      queryParameters: <String, dynamic>{'limit': limit},
    );

    final raw = response.data;
    if (raw is! List) {
      return const <SoundModel>[];
    }

    return raw
        .whereType<Map<String, dynamic>>()
        .map(_safeSoundFromJson)
        .toList(growable: false);
  }

  Future<SoundModel> getSound(String soundUid) async {
    final response = await _dio.get('/api/sounds/$soundUid');
    return _safeSoundFromJson(response.data as Map<String, dynamic>);
  }

  Future<List<String>> getGenres() async {
    final response = await _dio.get('/api/sounds/genres');
    final raw = response.data;
    if (raw is! List) {
      return const <String>[];
    }
    return raw.map((item) => item.toString()).toList(growable: false);
  }

  Future<void> incrementUsage(String soundUid) async {
    await _dio.post('/api/sounds/$soundUid/use');
  }

  SoundModel _safeSoundFromJson(Map<String, dynamic> json) {
    try {
      return SoundModel.fromJson(json);
    } catch (_) {
      return SoundModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        uid: (json['uid'] ?? '').toString(),
        title: (json['title'] ?? 'Original Sound').toString(),
        artist: (json['artist'] ?? 'Unknown').toString(),
        audioUrl: (json['audioUrl'] ?? '').toString(),
        createdAt: (json['createdAt'] ?? '').toString(),
      );
    }
  }
}
