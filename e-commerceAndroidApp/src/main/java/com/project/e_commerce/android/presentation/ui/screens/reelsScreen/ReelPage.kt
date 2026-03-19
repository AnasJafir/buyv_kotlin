package com.project.e_commerce.android.presentation.ui.screens.reelsScreen

import android.util.Log
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.Icon
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.runtime.*
import androidx.compose.runtime.snapshots.SnapshotStateMap
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.project.e_commerce.android.R
import com.project.e_commerce.android.data.repository.TrackingRepository
import com.project.e_commerce.android.presentation.ui.navigation.Screens
import com.project.e_commerce.android.presentation.ui.screens.HeartAnimation
import com.project.e_commerce.android.presentation.ui.screens.RequireLoginPrompt
import com.project.e_commerce.android.presentation.ui.screens.reelsScreen.components.ReelContent
import com.project.e_commerce.android.presentation.viewModel.CartViewModel
import com.project.e_commerce.android.presentation.viewModel.reelsScreenViewModel.ReelsScreenViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * A single page within the vertical reels pager.
 *
 * Handles:
 * - Media rendering (video, images, or video+images carousel) via [ReelMediaContent]
 * - Double-tap heart animation
 * - Play/pause overlay
 * - Bottom content overlay (product info, interaction buttons) via [ReelContent]
 * - View tracking for analytics
 */
@Composable
fun ReelPage(
    reel: Reels,
    page: Int,
    isCurrentPage: Boolean,
    isPlaying: Boolean,
    navController: NavController,
    viewModel: ReelsScreenViewModel,
    cartViewModel: CartViewModel,
    isLoggedIn: Boolean,
    showLoginPrompt: MutableState<Boolean>,
    globalVideoPlayStates: SnapshotStateMap<String, Boolean>,
    trackingRepository: TrackingRepository,
    onOpenComments: (Reels) -> Unit,
    onOpenBuySheet: (Reels) -> Unit,
    onShareReel: (Reels) -> Unit
) {
    val scope = rememberCoroutineScope()

    // --- Content validation ---
    val hasValidVideo = reel.video != null && !reel.isError
            && reel.video.toString().startsWith("http")
    val validImages = reel.images
        ?.filter { it != null && it.toString().startsWith("http") } ?: emptyList()

    if (!hasValidVideo && validImages.isEmpty()) {
        // Fallback for posts with no valid media
        Box(
            Modifier
                .fillMaxSize()
                .background(Color.Black),
            contentAlignment = Alignment.Center
        ) {
            androidx.compose.foundation.Image(
                painter = painterResource(id = R.drawable.profile),
                contentDescription = "Fallback",
                modifier = Modifier.fillMaxSize(),
                contentScale = androidx.compose.ui.layout.ContentScale.Crop
            )
        }
        return
    }

    // --- Per-reel heart animation state ---
    var showHeart by remember(reel.id) { mutableStateOf(false) }
    var heartPosition by remember(reel.id) { mutableStateOf(Offset.Zero) }

    // --- Play/pause overlay state ---
    var playOverlayTrigger by remember(reel.id) { mutableStateOf(0) }
    var showPlayPauseOverlay by remember(reel.id) { mutableStateOf(false) }
    var overlayShowsPlay by remember(reel.id) { mutableStateOf(true) }
    LaunchedEffect(playOverlayTrigger) {
        if (playOverlayTrigger > 0) {
            showPlayPauseOverlay = true
            delay(1500)
            showPlayPauseOverlay = false
        }
    }

    // --- View tracking ---
    LaunchedEffect(page, isCurrentPage, reel.id) {
        if (isCurrentPage) {
            delay(1000)
            if (isCurrentPage) {
                scope.launch {
                    try {
                        trackingRepository.trackReelView(
                            reelId = reel.id,
                            promoterUid = reel.userId,
                            productId = reel.marketplaceProductId,
                            watchDuration = null,
                            completionRate = null
                        )
                    } catch (e: Exception) {
                        Log.e("ReelPage", "Failed to track view: ${e.message}")
                    }
                }
            }
        }
    }

    // --- On double tap ---
    val onDoubleTap: (Offset) -> Unit = { tapOffset ->
        if (isLoggedIn) {
            heartPosition = tapOffset
            showHeart = true
            if (!reel.love.isLoved) viewModel.onClackLoveReelsButton(reel.id)
        } else {
            showLoginPrompt.value = true
        }
    }

    val onPlaybackToggle: (Boolean) -> Unit = { isNowPlaying ->
        globalVideoPlayStates[reel.id] = isNowPlaying
        overlayShowsPlay = isNowPlaying
        playOverlayTrigger++
        if (isNowPlaying) {
            globalVideoPlayStates.keys.forEach { id ->
                if (id != reel.id) globalVideoPlayStates[id] = false
            }
        }
    }

    // --- Layout ---
    Box(Modifier.fillMaxSize()) {

        // Media content (video, images, or carousel)
        ReelMediaContent(
            reel = reel,
            hasValidVideo = hasValidVideo,
            validImages = validImages,
            isPlaying = isPlaying,
            isCurrentPage = isCurrentPage,
            onDoubleTap = onDoubleTap,
            onPlaybackToggle = onPlaybackToggle,
            isLoggedIn = isLoggedIn,
            showLoginPrompt = showLoginPrompt,
            viewModel = viewModel
        )

        // Bottom overlay: product info + interaction buttons
        ReelContent(
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.BottomStart),
            navController = navController,
            reel = reel,
            viewModel = viewModel,
            cartViewModel = cartViewModel,
            onClickCommentButton = { onOpenComments(reel) },
            onClickCartButton = { onOpenBuySheet(reel) },
            onClickMoreButton = { onShareReel(reel) },
            showLoginPrompt = showLoginPrompt,
            isLoggedIn = isLoggedIn,
        )

        // Heart animation overlay
        if (showHeart) {
            HeartAnimation(
                isVisible = true,
                position = heartPosition,
                iconPainter = painterResource(id = R.drawable.ic_love_checked),
                onAnimationEnd = { showHeart = false },
                iconSize = 100.dp
            )
        }

        // Play/Pause tap-feedback overlay
        AnimatedVisibility(
            visible = showPlayPauseOverlay,
            enter = fadeIn(animationSpec = tween(150)),
            exit = fadeOut(animationSpec = tween(400)),
            modifier = Modifier.align(Alignment.Center)
        ) {
            Icon(
                imageVector = if (overlayShowsPlay) Icons.Filled.PlayArrow else Icons.Filled.Pause,
                contentDescription = null,
                tint = Color.White.copy(alpha = 0.85f),
                modifier = Modifier
                    .size(80.dp)
                    .background(Color.Black.copy(alpha = 0.40f), shape = CircleShape)
                    .padding(16.dp)
            )
        }

        // Login prompt overlay
        if (showLoginPrompt.value) {
            RequireLoginPrompt(
                onLogin = {
                    showLoginPrompt.value = false
                    navController.navigate(Screens.LoginScreen.route)
                },
                onSignUp = {
                    showLoginPrompt.value = false
                    navController.navigate(Screens.LoginScreen.CreateAccountScreen.route)
                },
                onDismiss = { showLoginPrompt.value = false }
            )
        }
    }
}
