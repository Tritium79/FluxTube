import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluxtube/domain/channel/models/newpipe/newpipe_channel_resp.dart';
import 'package:fluxtube/domain/search/models/newpipe/newpipe_search_resp.dart';
import 'package:fluxtube/domain/trending/models/newpipe/newpipe_trending_resp.dart';
import 'package:fluxtube/domain/watch/models/newpipe/newpipe_comments_resp.dart';
import 'package:fluxtube/domain/watch/models/newpipe/newpipe_watch_resp.dart';

/// Platform channel for communicating with NewPipe Extractor on Android.
/// This service is Android-only. On iOS, it returns unavailable.
class NewPipeChannel {
  static const _channel = MethodChannel('com.fazilvk.fluxtube/newpipe');

  /// Check if NewPipe Extractor is available on this platform.
  /// Returns true on Android, false on iOS/other platforms.
  static Future<bool> get isAvailable async {
    if (!Platform.isAndroid) {
      return false;
    }
    try {
      final result = await _channel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Get video stream info including metadata and stream URLs
  static Future<NewPipeWatchResp> getStreamInfo(String videoId) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'getStreamInfo',
        {'id': videoId},
      );
      if (result == null) {
        throw PlatformException(
          code: 'NULL_RESULT',
          message: 'No data returned from NewPipe Extractor',
        );
      }
      final json = jsonDecode(result) as Map<String, dynamic>;
      return NewPipeWatchResp.fromJson(json);
    } on PlatformException catch (e) {
      throw Exception('Failed to get stream info: ${e.message}');
    }
  }

  /// Get trending videos for a specific region
  static Future<List<NewPipeTrendingResp>> getTrending(String region) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'getTrending',
        {'region': region},
      );
      if (result == null) {
        throw PlatformException(
          code: 'NULL_RESULT',
          message: 'No data returned from NewPipe Extractor',
        );
      }
      final json = jsonDecode(result) as Map<String, dynamic>;
      final videos = json['videos'] as List<dynamic>?;
      if (videos == null) return [];
      return videos
          .map((v) => NewPipeTrendingResp.fromJson(v as Map<String, dynamic>))
          .toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get trending: ${e.message}');
    }
  }

  /// Search for videos, channels, or playlists
  static Future<NewPipeSearchResp> search({
    required String query,
    required String filter,
    String? nextPage,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'search',
        {
          'query': query,
          'filter': filter,
          if (nextPage != null) 'nextPage': nextPage,
        },
      );
      if (result == null) {
        throw PlatformException(
          code: 'NULL_RESULT',
          message: 'No data returned from NewPipe Extractor',
        );
      }
      final json = jsonDecode(result) as Map<String, dynamic>;
      return NewPipeSearchResp.fromJson(json);
    } on PlatformException catch (e) {
      throw Exception('Failed to search: ${e.message}');
    }
  }

  /// Get search suggestions for autocomplete
  static Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'getSearchSuggestions',
        {'query': query},
      );
      if (result == null) return [];
      final json = jsonDecode(result) as List<dynamic>;
      return json.map((s) => s.toString()).toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get suggestions: ${e.message}');
    }
  }

  /// Get channel info and videos
  static Future<NewPipeChannelResp> getChannel(String channelId) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'getChannel',
        {'id': channelId},
      );
      if (result == null) {
        throw PlatformException(
          code: 'NULL_RESULT',
          message: 'No data returned from NewPipe Extractor',
        );
      }
      final json = jsonDecode(result) as Map<String, dynamic>;
      return NewPipeChannelResp.fromJson(json);
    } on PlatformException catch (e) {
      throw Exception('Failed to get channel: ${e.message}');
    }
  }

  /// Get comments for a video
  static Future<NewPipeCommentsResp> getComments(String videoId) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'getComments',
        {'id': videoId},
      );
      if (result == null) {
        throw PlatformException(
          code: 'NULL_RESULT',
          message: 'No data returned from NewPipe Extractor',
        );
      }
      final json = jsonDecode(result) as Map<String, dynamic>;
      return NewPipeCommentsResp.fromJson(json);
    } on PlatformException catch (e) {
      throw Exception('Failed to get comments: ${e.message}');
    }
  }

  /// Get more comments (pagination)
  static Future<NewPipeCommentsResp> getMoreComments({
    required String videoId,
    required String nextPage,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'getMoreComments',
        {
          'id': videoId,
          'nextPage': nextPage,
        },
      );
      if (result == null) {
        throw PlatformException(
          code: 'NULL_RESULT',
          message: 'No data returned from NewPipe Extractor',
        );
      }
      final json = jsonDecode(result) as Map<String, dynamic>;
      return NewPipeCommentsResp.fromJson(json);
    } on PlatformException catch (e) {
      throw Exception('Failed to get more comments: ${e.message}');
    }
  }
}
