package com.fazilvk.fluxtube.newpipe

import android.os.Handler
import android.os.Looper
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import org.schabi.newpipe.extractor.InfoItem
import org.schabi.newpipe.extractor.NewPipe
import org.schabi.newpipe.extractor.ServiceList
import org.schabi.newpipe.extractor.channel.ChannelInfo
import org.schabi.newpipe.extractor.comments.CommentsInfo
import org.schabi.newpipe.extractor.kiosk.KioskInfo
import org.schabi.newpipe.extractor.localization.ContentCountry
import org.schabi.newpipe.extractor.localization.Localization
import org.schabi.newpipe.extractor.playlist.PlaylistInfo
import org.schabi.newpipe.extractor.search.SearchInfo
import org.schabi.newpipe.extractor.stream.StreamInfo
import org.schabi.newpipe.extractor.stream.AudioStream
import org.schabi.newpipe.extractor.stream.VideoStream
import org.schabi.newpipe.extractor.suggestion.SuggestionExtractor

/**
 * Handles all method channel calls from Flutter for NewPipe Extractor operations.
 * All extraction runs on background threads using Kotlin Coroutines.
 */
class NewPipeMethodHandler : MethodChannel.MethodCallHandler {

    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val mainHandler = Handler(Looper.getMainLooper())
    private val gson: Gson = GsonBuilder()
        .serializeNulls()
        .create()

    companion object {
        private var isInitialized = false

        fun initialize() {
            if (!isInitialized) {
                NewPipe.init(FluxTubeDownloader.getInstance())
                isInitialized = true
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        initialize()

        when (call.method) {
            "isAvailable" -> result.success(true)
            "getStreamInfo" -> handleGetStreamInfo(call, result)
            "getTrending" -> handleGetTrending(call, result)
            "search" -> handleSearch(call, result)
            "getSearchSuggestions" -> handleGetSearchSuggestions(call, result)
            "getChannel" -> handleGetChannel(call, result)
            "getComments" -> handleGetComments(call, result)
            "getMoreComments" -> handleGetMoreComments(call, result)
            "getCommentReplies" -> handleGetCommentReplies(call, result)
            "getPlaylist" -> handleGetPlaylist(call, result)
            "getRelatedStreams" -> handleGetRelatedStreams(call, result)
            else -> result.notImplemented()
        }
    }

    /**
     * Get video stream info (video details, streams, etc.)
     */
    private fun handleGetStreamInfo(call: MethodCall, result: MethodChannel.Result) {
        val videoId = call.argument<String>("id") ?: run {
            result.error("INVALID_ARGUMENT", "Video ID is required", null)
            return
        }

        scope.launch {
            try {
                val url = "https://www.youtube.com/watch?v=$videoId"
                val streamInfo = StreamInfo.getInfo(ServiceList.YouTube, url)

                // Get the best quality thumbnail
                val bestThumbnail = streamInfo.thumbnails.maxByOrNull { it.width * it.height }?.url
                    ?: streamInfo.thumbnails.lastOrNull()?.url

                val response = mapOf(
                    "id" to streamInfo.id,
                    "title" to streamInfo.name,
                    "description" to streamInfo.description?.content,
                    "uploaderName" to streamInfo.uploaderName,
                    "uploaderUrl" to streamInfo.uploaderUrl,
                    "uploaderAvatarUrl" to streamInfo.uploaderAvatars.firstOrNull()?.url,
                    "uploaderVerified" to streamInfo.isUploaderVerified,
                    "uploaderSubscriberCount" to streamInfo.uploaderSubscriberCount,
                    "thumbnailUrl" to bestThumbnail,
                    "duration" to streamInfo.duration,
                    "viewCount" to streamInfo.viewCount,
                    "likeCount" to streamInfo.likeCount,
                    "dislikeCount" to streamInfo.dislikeCount,
                    "uploadDate" to streamInfo.uploadDate?.offsetDateTime()?.toString(),
                    "textualUploadDate" to streamInfo.textualUploadDate,
                    "category" to streamInfo.category,
                    "tags" to streamInfo.tags?.toList(),
                    "isLive" to (streamInfo.streamType.name == "LIVE_STREAM"),
                    "hlsUrl" to streamInfo.hlsUrl,
                    "dashMpdUrl" to streamInfo.dashMpdUrl,
                    "audioStreams" to streamInfo.audioStreams.map { mapAudioStream(it) },
                    "videoStreams" to streamInfo.videoStreams.map { mapVideoStream(it) },
                    "videoOnlyStreams" to streamInfo.videoOnlyStreams.map { mapVideoStream(it) },
                    "relatedStreams" to streamInfo.relatedItems.take(20).map { mapInfoItem(it) },
                    "subtitles" to streamInfo.subtitles.map { subtitle ->
                        mapOf(
                            "url" to subtitle.content,
                            "mimeType" to subtitle.format?.mimeType,
                            "languageCode" to subtitle.languageTag,
                            "autoGenerated" to subtitle.isAutoGenerated
                        )
                    }
                )

                sendSuccess(result, gson.toJson(response))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to extract stream info", null)
            }
        }
    }

    /**
     * Get trending videos for a specific region
     */
    private fun handleGetTrending(call: MethodCall, result: MethodChannel.Result) {
        val region = call.argument<String>("region") ?: "US"

        scope.launch {
            try {
                val service = ServiceList.YouTube
                val kiosk = service.kioskList.defaultKioskExtractor

                // Set content country for region-specific trending
                NewPipe.setupLocalization(
                    Localization.DEFAULT,
                    ContentCountry(region)
                )

                val kioskInfo = KioskInfo.getInfo(service, kiosk.url)

                val videos = kioskInfo.relatedItems.map { mapInfoItem(it) }

                val response = mapOf(
                    "videos" to videos,
                    "nextPage" to kioskInfo.nextPage?.url
                )

                sendSuccess(result, gson.toJson(response))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to get trending", null)
            }
        }
    }

    /**
     * Search for videos, channels, or playlists
     */
    private fun handleSearch(call: MethodCall, result: MethodChannel.Result) {
        val query = call.argument<String>("query") ?: run {
            result.error("INVALID_ARGUMENT", "Query is required", null)
            return
        }
        val filter = call.argument<String>("filter") ?: "all"
        val nextPage = call.argument<String>("nextPage")

        scope.launch {
            try {
                val service = ServiceList.YouTube
                val contentFilters = when (filter) {
                    "videos" -> listOf("videos")
                    "channels" -> listOf("channels")
                    "playlists" -> listOf("playlists")
                    "music_songs" -> listOf("music_songs")
                    else -> emptyList()
                }

                val searchInfo = if (nextPage != null) {
                    SearchInfo.getMoreItems(
                        service,
                        service.searchQHFactory.fromQuery(query, contentFilters, ""),
                        org.schabi.newpipe.extractor.Page(nextPage)
                    ).let { moreItems ->
                        // Create a minimal response for pagination
                        mapOf(
                            "items" to moreItems.items.map { mapInfoItem(it) },
                            "nextPage" to moreItems.nextPage?.url
                        )
                    }
                } else {
                    val info = SearchInfo.getInfo(
                        service,
                        service.searchQHFactory.fromQuery(query, contentFilters, "")
                    )
                    mapOf(
                        "items" to info.relatedItems.map { mapInfoItem(it) },
                        "nextPage" to info.nextPage?.url,
                        "searchSuggestion" to info.searchSuggestion,
                        "isCorrectedSearch" to info.isCorrectedSearch
                    )
                }

                sendSuccess(result, gson.toJson(searchInfo))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to search", null)
            }
        }
    }

    /**
     * Get search suggestions
     */
    private fun handleGetSearchSuggestions(call: MethodCall, result: MethodChannel.Result) {
        val query = call.argument<String>("query") ?: run {
            result.error("INVALID_ARGUMENT", "Query is required", null)
            return
        }

        scope.launch {
            try {
                val extractor = ServiceList.YouTube.suggestionExtractor
                val suggestions = extractor.suggestionList(query)
                sendSuccess(result, gson.toJson(suggestions))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to get suggestions", null)
            }
        }
    }

    /**
     * Get channel info
     */
    private fun handleGetChannel(call: MethodCall, result: MethodChannel.Result) {
        val channelId = call.argument<String>("id") ?: run {
            result.error("INVALID_ARGUMENT", "Channel ID is required", null)
            return
        }

        scope.launch {
            try {
                val url = if (channelId.startsWith("http")) {
                    channelId
                } else {
                    "https://www.youtube.com/channel/$channelId"
                }

                val channelInfo = ChannelInfo.getInfo(ServiceList.YouTube, url)

                // Get initial videos from the first tab (usually "Videos")
                var initialVideos: List<Map<String, Any?>> = emptyList()
                var videosNextPage: String? = null

                if (channelInfo.tabs.isNotEmpty()) {
                    try {
                        // Find the videos tab or use the first tab
                        val videosTab = channelInfo.tabs.find { tab ->
                            tab.contentFilters.any { it.contains("videos", ignoreCase = true) }
                        } ?: channelInfo.tabs.firstOrNull()

                        if (videosTab != null) {
                            val tabExtractor = ServiceList.YouTube.getChannelTabExtractor(videosTab)
                            tabExtractor.fetchPage()
                            val initialPage = tabExtractor.initialPage
                            initialVideos = initialPage.items.map { mapInfoItem(it) }
                            videosNextPage = initialPage.nextPage?.url
                        }
                    } catch (tabError: Exception) {
                        // If tab extraction fails, continue without videos
                        android.util.Log.w("NewPipeHandler", "Failed to get videos tab: ${tabError.message}")
                    }
                }

                // Get best quality avatar and banner
                val bestAvatar = channelInfo.avatars.maxByOrNull { it.width * it.height }?.url
                    ?: channelInfo.avatars.lastOrNull()?.url
                val bestBanner = channelInfo.banners.maxByOrNull { it.width * it.height }?.url
                    ?: channelInfo.banners.lastOrNull()?.url

                val response = mapOf(
                    "id" to channelInfo.id,
                    "name" to channelInfo.name,
                    "description" to channelInfo.description,
                    "avatarUrl" to bestAvatar,
                    "bannerUrl" to bestBanner,
                    "subscriberCount" to channelInfo.subscriberCount,
                    "isVerified" to channelInfo.isVerified,
                    "videos" to initialVideos,
                    "nextPage" to videosNextPage,
                    "tabs" to channelInfo.tabs.map { tab ->
                        mapOf(
                            "name" to tab.contentFilters.firstOrNull(),
                            "url" to tab.url
                        )
                    }
                )

                sendSuccess(result, gson.toJson(response))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to get channel", null)
            }
        }
    }

    /**
     * Get comments for a video
     */
    private fun handleGetComments(call: MethodCall, result: MethodChannel.Result) {
        val videoId = call.argument<String>("id") ?: run {
            result.error("INVALID_ARGUMENT", "Video ID is required", null)
            return
        }

        scope.launch {
            try {
                val url = "https://www.youtube.com/watch?v=$videoId"
                val commentsInfo = CommentsInfo.getInfo(ServiceList.YouTube, url)

                val response = mapOf(
                    "comments" to commentsInfo.relatedItems.map { comment ->
                        mapOf(
                            "id" to comment.commentId,
                            "text" to comment.commentText?.content,
                            "authorName" to comment.uploaderName,
                            "authorUrl" to comment.uploaderUrl,
                            "authorAvatarUrl" to comment.uploaderAvatars.firstOrNull()?.url,
                            "authorVerified" to comment.isUploaderVerified,
                            "likeCount" to comment.likeCount,
                            "replyCount" to comment.replyCount,
                            "isPinned" to comment.isPinned,
                            "isHearted" to comment.isHeartedByUploader,
                            "uploadDate" to comment.textualUploadDate,
                            "repliesPage" to serializePage(comment.replies)
                        )
                    },
                    "nextPage" to serializePage(commentsInfo.nextPage),
                    "commentCount" to commentsInfo.commentsCount,
                    "isDisabled" to commentsInfo.isCommentsDisabled
                )

                sendSuccess(result, gson.toJson(response))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to get comments", null)
            }
        }
    }

    /**
     * Get more comments (pagination)
     */
    private fun handleGetMoreComments(call: MethodCall, result: MethodChannel.Result) {
        val videoId = call.argument<String>("id") ?: run {
            result.error("INVALID_ARGUMENT", "Video ID is required", null)
            return
        }
        val nextPageJson = call.argument<String>("nextPage") ?: run {
            result.error("INVALID_ARGUMENT", "Next page is required", null)
            return
        }

        scope.launch {
            try {
                val url = "https://www.youtube.com/watch?v=$videoId"
                val page = deserializePage(nextPageJson)
                val moreComments = CommentsInfo.getMoreItems(
                    ServiceList.YouTube,
                    url,
                    page
                )

                val response = mapOf(
                    "comments" to moreComments.items.map { comment ->
                        mapOf(
                            "id" to comment.commentId,
                            "text" to comment.commentText?.content,
                            "authorName" to comment.uploaderName,
                            "authorUrl" to comment.uploaderUrl,
                            "authorAvatarUrl" to comment.uploaderAvatars.firstOrNull()?.url,
                            "authorVerified" to comment.isUploaderVerified,
                            "likeCount" to comment.likeCount,
                            "replyCount" to comment.replyCount,
                            "isPinned" to comment.isPinned,
                            "isHearted" to comment.isHeartedByUploader,
                            "uploadDate" to comment.textualUploadDate,
                            "repliesPage" to serializePage(comment.replies)
                        )
                    },
                    "nextPage" to serializePage(moreComments.nextPage)
                )

                sendSuccess(result, gson.toJson(response))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to get more comments", null)
            }
        }
    }

    /**
     * Get comment replies
     */
    private fun handleGetCommentReplies(call: MethodCall, result: MethodChannel.Result) {
        val videoId = call.argument<String>("id") ?: run {
            result.error("INVALID_ARGUMENT", "Video ID is required", null)
            return
        }
        val repliesPageJson = call.argument<String>("repliesPage") ?: run {
            result.error("INVALID_ARGUMENT", "Replies page is required", null)
            return
        }

        scope.launch {
            try {
                val url = "https://www.youtube.com/watch?v=$videoId"
                val page = deserializePage(repliesPageJson)
                val replies = CommentsInfo.getMoreItems(
                    ServiceList.YouTube,
                    url,
                    page
                )

                val response = mapOf(
                    "comments" to replies.items.map { comment ->
                        mapOf(
                            "id" to comment.commentId,
                            "text" to comment.commentText?.content,
                            "authorName" to comment.uploaderName,
                            "authorUrl" to comment.uploaderUrl,
                            "authorAvatarUrl" to comment.uploaderAvatars.firstOrNull()?.url,
                            "authorVerified" to comment.isUploaderVerified,
                            "likeCount" to comment.likeCount,
                            "replyCount" to comment.replyCount,
                            "isPinned" to comment.isPinned,
                            "isHearted" to comment.isHeartedByUploader,
                            "uploadDate" to comment.textualUploadDate,
                            "repliesPage" to serializePage(comment.replies)
                        )
                    },
                    "nextPage" to serializePage(replies.nextPage)
                )

                sendSuccess(result, gson.toJson(response))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to get comment replies", null)
            }
        }
    }

    /**
     * Get playlist info
     */
    private fun handleGetPlaylist(call: MethodCall, result: MethodChannel.Result) {
        val playlistId = call.argument<String>("id") ?: run {
            result.error("INVALID_ARGUMENT", "Playlist ID is required", null)
            return
        }

        scope.launch {
            try {
                val url = if (playlistId.startsWith("http")) {
                    playlistId
                } else {
                    "https://www.youtube.com/playlist?list=$playlistId"
                }

                val playlistInfo = PlaylistInfo.getInfo(ServiceList.YouTube, url)

                // Get best quality thumbnails
                val bestPlaylistThumbnail = playlistInfo.thumbnails.maxByOrNull { it.width * it.height }?.url
                    ?: playlistInfo.thumbnails.lastOrNull()?.url
                val bestUploaderAvatar = playlistInfo.uploaderAvatars.maxByOrNull { it.width * it.height }?.url
                    ?: playlistInfo.uploaderAvatars.lastOrNull()?.url

                val response = mapOf(
                    "id" to playlistInfo.id,
                    "name" to playlistInfo.name,
                    "thumbnailUrl" to bestPlaylistThumbnail,
                    "uploaderName" to playlistInfo.uploaderName,
                    "uploaderUrl" to playlistInfo.uploaderUrl,
                    "uploaderAvatarUrl" to bestUploaderAvatar,
                    "streamCount" to playlistInfo.streamCount,
                    "videos" to playlistInfo.relatedItems.map { mapInfoItem(it) },
                    "nextPage" to playlistInfo.nextPage?.url
                )

                sendSuccess(result, gson.toJson(response))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to get playlist", null)
            }
        }
    }

    /**
     * Get related streams for a video
     */
    private fun handleGetRelatedStreams(call: MethodCall, result: MethodChannel.Result) {
        val videoId = call.argument<String>("id") ?: run {
            result.error("INVALID_ARGUMENT", "Video ID is required", null)
            return
        }

        scope.launch {
            try {
                val url = "https://www.youtube.com/watch?v=$videoId"
                val streamInfo = StreamInfo.getInfo(ServiceList.YouTube, url)

                val relatedVideos = streamInfo.relatedItems.map { mapInfoItem(it) }
                sendSuccess(result, gson.toJson(relatedVideos))
            } catch (e: Exception) {
                sendError(result, "EXTRACTION_ERROR", e.message ?: "Failed to get related streams", null)
            }
        }
    }

    // Helper methods

    private fun mapAudioStream(stream: AudioStream): Map<String, Any?> {
        val itagItem = stream.itagItem
        return mapOf(
            "url" to stream.content,
            "averageBitrate" to stream.averageBitrate,
            "format" to stream.format?.name,
            "mimeType" to stream.format?.mimeType,
            "codec" to stream.codec,
            "quality" to stream.quality,
            "id" to stream.id,
            "itag" to stream.itag,
            // DASH manifest fields from ItagItem
            "initStart" to itagItem?.initStart,
            "initEnd" to itagItem?.initEnd,
            "indexStart" to itagItem?.indexStart,
            "indexEnd" to itagItem?.indexEnd,
            "contentLength" to itagItem?.contentLength,
            "bitrate" to itagItem?.bitrate,
            "approxDurationMs" to itagItem?.approxDurationMs,
            "audioChannels" to itagItem?.audioChannels,
            "sampleRate" to itagItem?.sampleRate
        )
    }

    private fun mapVideoStream(stream: VideoStream): Map<String, Any?> {
        val itagItem = stream.itagItem
        return mapOf(
            "url" to stream.content,
            "resolution" to stream.resolution,
            "format" to stream.format?.name,
            "mimeType" to stream.format?.mimeType,
            "codec" to stream.codec,
            "quality" to stream.quality,
            "width" to stream.width,
            "height" to stream.height,
            "fps" to stream.fps,
            "isVideoOnly" to stream.isVideoOnly,
            "id" to stream.id,
            "itag" to stream.itag,
            // DASH manifest fields from ItagItem
            "initStart" to itagItem?.initStart,
            "initEnd" to itagItem?.initEnd,
            "indexStart" to itagItem?.indexStart,
            "indexEnd" to itagItem?.indexEnd,
            "contentLength" to itagItem?.contentLength,
            "bitrate" to itagItem?.bitrate,
            "approxDurationMs" to itagItem?.approxDurationMs
        )
    }

    private fun mapInfoItem(item: InfoItem): Map<String, Any?> {
        // Get the best quality thumbnail (last one is usually highest resolution)
        val bestThumbnail = item.thumbnails.maxByOrNull { it.width * it.height }?.url
            ?: item.thumbnails.lastOrNull()?.url

        return mapOf(
            "url" to item.url,
            "name" to item.name,
            "thumbnailUrl" to bestThumbnail,
            "type" to item.infoType.name,
            // Stream-specific fields
            "uploaderName" to (item as? org.schabi.newpipe.extractor.stream.StreamInfoItem)?.uploaderName,
            "uploaderUrl" to (item as? org.schabi.newpipe.extractor.stream.StreamInfoItem)?.uploaderUrl,
            "uploaderAvatarUrl" to (item as? org.schabi.newpipe.extractor.stream.StreamInfoItem)?.uploaderAvatars?.firstOrNull()?.url,
            "uploaderVerified" to (item as? org.schabi.newpipe.extractor.stream.StreamInfoItem)?.isUploaderVerified,
            "duration" to (item as? org.schabi.newpipe.extractor.stream.StreamInfoItem)?.duration,
            "viewCount" to (item as? org.schabi.newpipe.extractor.stream.StreamInfoItem)?.viewCount,
            "uploadDate" to (item as? org.schabi.newpipe.extractor.stream.StreamInfoItem)?.textualUploadDate,
            "isLive" to ((item as? org.schabi.newpipe.extractor.stream.StreamInfoItem)?.streamType?.name == "LIVE_STREAM"),
            "isShort" to (item as? org.schabi.newpipe.extractor.stream.StreamInfoItem)?.isShortFormContent,
            // Channel-specific fields
            "subscriberCount" to (item as? org.schabi.newpipe.extractor.channel.ChannelInfoItem)?.subscriberCount,
            "isVerified" to (item as? org.schabi.newpipe.extractor.channel.ChannelInfoItem)?.isVerified,
            "description" to (item as? org.schabi.newpipe.extractor.channel.ChannelInfoItem)?.description,
            // Playlist-specific fields
            "streamCount" to (item as? org.schabi.newpipe.extractor.playlist.PlaylistInfoItem)?.streamCount
        )
    }

    /**
     * Serialize a Page object to JSON string for passing through MethodChannel
     */
    private fun serializePage(page: org.schabi.newpipe.extractor.Page?): String? {
        if (page == null) return null

        val pageMap = mapOf(
            "url" to page.url,
            "id" to page.id,
            "ids" to page.ids,
            "body" to page.body?.let { android.util.Base64.encodeToString(it, android.util.Base64.NO_WRAP) }
        )
        return gson.toJson(pageMap)
    }

    /**
     * Deserialize a JSON string back to a Page object
     */
    private fun deserializePage(json: String): org.schabi.newpipe.extractor.Page {
        val pageMap = gson.fromJson(json, Map::class.java)
        val url = pageMap["url"] as? String
        val id = pageMap["id"] as? String
        @Suppress("UNCHECKED_CAST")
        val ids = (pageMap["ids"] as? List<*>)?.filterIsInstance<String>()
        val bodyBase64 = pageMap["body"] as? String
        val body = bodyBase64?.let { android.util.Base64.decode(it, android.util.Base64.NO_WRAP) }

        return when {
            ids != null && body != null -> org.schabi.newpipe.extractor.Page(url, id, ids, null, body)
            ids != null -> org.schabi.newpipe.extractor.Page(ids)
            body != null -> org.schabi.newpipe.extractor.Page(url, id, body)
            id != null -> org.schabi.newpipe.extractor.Page(url, id)
            url != null -> org.schabi.newpipe.extractor.Page(url)
            else -> throw IllegalArgumentException("Invalid Page data: no url or ids provided")
        }
    }

    private fun sendSuccess(result: MethodChannel.Result, data: String) {
        mainHandler.post {
            result.success(data)
        }
    }

    private fun sendError(result: MethodChannel.Result, code: String, message: String, details: Any?) {
        mainHandler.post {
            result.error(code, message, details)
        }
    }

    /**
     * Clean up resources when no longer needed
     */
    fun dispose() {
        scope.cancel()
    }
}
