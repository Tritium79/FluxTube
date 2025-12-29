import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fluxtube/domain/core/failure/main_failure.dart';
import 'package:fluxtube/domain/home/home_services.dart';
import 'package:fluxtube/domain/subscribes/models/subscribe.dart';
import 'package:fluxtube/domain/trending/models/newpipe/newpipe_trending_resp.dart';
import 'package:fluxtube/domain/trending/models/piped/trending_resp.dart';
import 'package:fluxtube/infrastructure/newpipe/newpipe_channel.dart';
import 'package:injectable/injectable.dart';

import '../../domain/core/api_end_points.dart';

@LazySingleton(as: HomeServices)
class HomeImpl extends HomeServices {
  @override
  Future<Either<MainFailure, List<TrendingResp>>> getHomeFeedData(
      {required List<Subscribe> channels}) async {
    final dioClient = Dio();
    try {
      final subscribedChannelIds =
          channels.map((channel) => channel.id.toString()).toList();
      final String idsAsString = subscribedChannelIds.join(",");

      final Response response = await dioClient.get(
        ApiEndPoints.feed + idsAsString,
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<TrendingResp> result = (response.data as List)
            .map((e) => TrendingResp.fromJson(e))
            .toList();

        return Right(result);
      } else {
        log('Err on getHomeFeedData: ${response.statusCode}');
        return const Left(MainFailure.serverFailure());
      }
    } catch (e) {
      log('Err on getHomeFeedData: $e');
      return const Left(MainFailure.clientFailure());
    } finally {
      dioClient.close();
    }
  }

  @override
  Future<Either<MainFailure, List<NewPipeTrendingResp>>> getNewPipeHomeFeedData(
      {required List<Subscribe> channels}) async {
    try {
      if (channels.isEmpty) {
        return const Right([]);
      }

      final List<NewPipeTrendingResp> allVideos = [];

      // Fetch videos from each subscribed channel (limit to 10 channels to avoid long delays)
      final channelsToFetch = channels.take(10).toList();

      for (final channel in channelsToFetch) {
        try {
          final channelInfo = await NewPipeChannel.getChannel(channel.id);
          if (channelInfo.videos != null) {
            // Add channel info to each video and take top 5 from each channel
            final channelVideos = channelInfo.videos!.take(5).map((video) {
              return NewPipeTrendingResp(
                url: video.url,
                name: video.name,
                thumbnailUrl: video.thumbnailUrl,
                type: video.type,
                uploaderName: channelInfo.name ?? channel.channelName,
                uploaderUrl: 'https://www.youtube.com/channel/${channel.id}',
                uploaderAvatarUrl: channelInfo.avatarUrl,
                uploaderVerified: channelInfo.isVerified,
                duration: video.duration,
                viewCount: video.viewCount,
                uploadDate: video.uploadDate,
                isLive: video.isLive,
                isShort: video.isShort,
              );
            }).toList();
            allVideos.addAll(channelVideos);
          }
        } catch (e) {
          log('Error fetching channel ${channel.id}: $e');
          // Continue with other channels even if one fails
          continue;
        }
      }

      // Sort by upload date (most recent first) - we need to parse dates
      // For now just return as is since uploadDate might not be parseable
      // The videos should already be in recent order from each channel

      // Shuffle to mix videos from different channels, then limit to 30
      allVideos.shuffle();
      final limitedVideos = allVideos.take(30).toList();

      return Right(limitedVideos);
    } catch (e) {
      log('Err on getNewPipeHomeFeedData: $e');
      return const Left(MainFailure.clientFailure());
    }
  }
}
