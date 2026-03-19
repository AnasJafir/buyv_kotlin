package com.project.e_commerce.android.presentation.ui.screens.reelsScreen

import android.net.Uri
import android.util.Log
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import com.project.e_commerce.android.presentation.ui.composable.composableScreen.public.VideoPlayer
import com.project.e_commerce.android.presentation.viewModel.reelsScreenViewModel.ReelsScreenViewModel
import org.koin.compose.koinInject

/**
 * Renders the media content for a single reel page.
 *
 * Three modes:
 * 1. Video + Images → HorizontalPager (video first, then images)
 * 2. Video only → Full-screen VideoPlayer
 * 3. Images only → HorizontalPager with optional audio playback
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun ReelMediaContent(
    reel: Reels,
    hasValidVideo: Boolean,
    validImages: List<Uri>,
    isPlaying: Boolean,
    isCurrentPage: Boolean,
    onDoubleTap: (Offset) -> Unit,
    onPlaybackToggle: (Boolean) -> Unit,
    isLoggedIn: Boolean,
    showLoginPrompt: MutableState<Boolean>,
    viewModel: ReelsScreenViewModel
) {
    when {
        // --- Mode 1: Video + Images carousel ---
        hasValidVideo && validImages.isNotEmpty() -> {
            VideoAndImagesCarousel(
                videoUri = reel.video!!,
                images = validImages,
                isPlaying = isPlaying,
                reelId = reel.id,
                onDoubleTap = onDoubleTap,
                onPlaybackToggle = onPlaybackToggle
            )
        }
        // --- Mode 2: Video only ---
        hasValidVideo -> {
            VideoPlayer(
                uri = reel.video!!,
                isPlaying = isPlaying,
                onPlaybackStarted = {},
                onPlaybackToggle = onPlaybackToggle,
                onDoubleTap = onDoubleTap,
                modifier = Modifier.fillMaxSize()
            )
        }
        // --- Mode 3: Images only (with optional audio) ---
        validImages.isNotEmpty() -> {
            ImagesOnlyContent(
                reel = reel,
                images = validImages,
                isCurrentPage = isCurrentPage,
                isPlaying = isPlaying,
                onDoubleTap = onDoubleTap
            )
        }
    }
}

/**
 * HorizontalPager with video as first page, followed by images.
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
private fun VideoAndImagesCarousel(
    videoUri: Uri,
    images: List<Uri>,
    isPlaying: Boolean,
    reelId: String,
    onDoubleTap: (Offset) -> Unit,
    onPlaybackToggle: (Boolean) -> Unit
) {
    val totalPages = 1 + images.size
    val pagerState = rememberPagerState(initialPage = 0, pageCount = { totalPages })

    Box(
        Modifier
            .fillMaxSize()
            .background(Color.Black)
    ) {
        HorizontalPager(
            state = pagerState,
            modifier = Modifier.fillMaxSize()
        ) { mediaIndex ->
            if (mediaIndex == 0) {
                val isVideoPageActive = pagerState.currentPage == 0
                VideoPlayer(
                    uri = videoUri,
                    isPlaying = isPlaying && isVideoPageActive,
                    onPlaybackStarted = {},
                    onPlaybackToggle = onPlaybackToggle,
                    onDoubleTap = onDoubleTap,
                    modifier = Modifier.fillMaxSize()
                )
            } else {
                ImagePage(
                    imageUri = images[mediaIndex - 1],
                    index = mediaIndex - 1,
                    reelId = reelId
                )
            }
        }

        // Page indicator dots
        if (totalPages > 1) {
            PagerIndicatorDots(
                pageCount = totalPages,
                currentPage = pagerState.currentPage,
                modifier = Modifier
                    .fillMaxWidth()
                    .align(Alignment.BottomCenter)
                    .padding(bottom = 120.dp)
            )
        }
    }
}

/**
 * Images-only content with optional audio playback for sound-attached posts.
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
private fun ImagesOnlyContent(
    reel: Reels,
    images: List<Uri>,
    isCurrentPage: Boolean,
    isPlaying: Boolean,
    onDoubleTap: (Offset) -> Unit
) {
    // Audio playback for image posts with a sound attached
    if (!reel.soundUid.isNullOrBlank() && isCurrentPage) {
        SoundPlayer(soundUid = reel.soundUid!!, isPlaying = isPlaying)
    }

    val pagerState = rememberPagerState(initialPage = 0, pageCount = { images.size })

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black)
            .pointerInput(reel.id) {
                detectTapGestures(onDoubleTap = { onDoubleTap(it) })
            }
    ) {
        HorizontalPager(
            state = pagerState,
            modifier = Modifier.fillMaxSize()
        ) { imgIndex ->
            ImagePage(
                imageUri = images[imgIndex],
                index = imgIndex,
                reelId = reel.id
            )
        }

        // Page indicator dots
        if (images.size > 1) {
            PagerIndicatorDots(
                pageCount = images.size,
                currentPage = pagerState.currentPage,
                modifier = Modifier
                    .fillMaxWidth()
                    .align(Alignment.BottomCenter)
                    .padding(bottom = 120.dp)
            )
        }
    }
}

/**
 * A single full-screen image with loading indicator.
 */
@Composable
private fun ImagePage(imageUri: Uri, index: Int, reelId: String) {
    var loaded by remember(imageUri) { mutableStateOf(false) }
    Box(
        Modifier
            .fillMaxSize()
            .background(Color.Black),
        contentAlignment = Alignment.Center
    ) {
        AsyncImage(
            model = imageUri.toString(),
            contentDescription = "Image $index",
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize(),
            onSuccess = { loaded = true },
            onError = {
                Log.e("ReelMediaContent", "Image load failed: reel $reelId, index=$index")
            }
        )
        if (!loaded) {
            CircularProgressIndicator(
                color = Color.White.copy(alpha = 0.7f),
                modifier = Modifier.size(48.dp)
            )
        }
    }
}

/**
 * Audio player for image posts that have a sound attached.
 */
@Composable
private fun SoundPlayer(soundUid: String, isPlaying: Boolean) {
    val soundApi: com.project.e_commerce.data.remote.api.SoundApiService = koinInject()
    var audioUrl by remember(soundUid) { mutableStateOf<String?>(null) }

    LaunchedEffect(soundUid) {
        if (soundUid.startsWith("http")) {
            audioUrl = soundUid
        } else {
            try {
                val sound = soundApi.getSound(soundUid)
                audioUrl = sound.audioUrl
            } catch (e: Exception) {
                Log.e("SoundPlayer", "Failed to fetch sound $soundUid: ${e.message}")
            }
        }
    }

    if (audioUrl != null) {
        DisposableEffect(audioUrl, isPlaying) {
            val mediaPlayer = android.media.MediaPlayer().apply {
                try {
                    setDataSource(audioUrl)
                    isLooping = true
                    prepareAsync()
                    setOnPreparedListener { if (isPlaying) start() }
                } catch (e: Exception) {
                    Log.e("SoundPlayer", "Audio player error: ${e.message}")
                }
            }
            onDispose {
                try {
                    if (mediaPlayer.isPlaying) mediaPlayer.stop()
                    mediaPlayer.release()
                } catch (_: Exception) {}
            }
        }
    }
}

/**
 * Row of indicator dots for HorizontalPager pages.
 */
@Composable
fun PagerIndicatorDots(
    pageCount: Int,
    currentPage: Int,
    modifier: Modifier = Modifier
) {
    Row(
        horizontalArrangement = Arrangement.Center,
        verticalAlignment = Alignment.CenterVertically,
        modifier = modifier
    ) {
        repeat(pageCount) { idx ->
            Box(
                modifier = Modifier
                    .padding(horizontal = 4.dp)
                    .size(if (currentPage == idx) 10.dp else 7.dp)
                    .background(
                        if (currentPage == idx) Color.White
                        else Color.White.copy(alpha = 0.5f),
                        shape = CircleShape
                    )
            )
        }
    }
}
