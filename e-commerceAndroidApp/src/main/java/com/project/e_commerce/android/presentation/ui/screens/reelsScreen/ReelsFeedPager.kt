package com.project.e_commerce.android.presentation.ui.screens.reelsScreen

import android.util.Log
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.pager.VerticalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.material.Text
import androidx.compose.runtime.*
import androidx.compose.runtime.snapshots.SnapshotStateMap
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.navigation.NavController
import com.project.e_commerce.android.data.repository.TrackingRepository
import com.project.e_commerce.android.presentation.utils.VideoPreloader
import com.project.e_commerce.android.presentation.viewModel.CartViewModel
import com.project.e_commerce.android.presentation.viewModel.RecentlyViewedViewModel
import com.project.e_commerce.android.presentation.viewModel.reelsScreenViewModel.ReelsScreenViewModel
import kotlinx.coroutines.delay

/**
 * Vertical pager that displays the "For you" reels feed.
 * Each page is a [ReelPage].
 *
 * Handles:
 * - Target reel scrolling (from profile grid tap)
 * - Scroll-to-top on new post
 * - Video play state management (only current page plays)
 * - Video preloading for smooth transitions
 * - View tracking for analytics
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun ReelsFeedPager(
    navController: NavController,
    reelsList: List<Reels>,
    viewModel: ReelsScreenViewModel,
    cartViewModel: CartViewModel,
    isLoggedIn: Boolean,
    showLoginPrompt: MutableState<Boolean>,
    targetReelId: String?,
    globalVideoPlayStates: SnapshotStateMap<String, Boolean>,
    mainUiStateViewModel: com.project.e_commerce.android.presentation.viewModel.MainUiStateViewModel?,
    recentlyViewedViewModel: RecentlyViewedViewModel,
    trackingRepository: TrackingRepository,
    onOpenComments: (Reels) -> Unit,
    onOpenBuySheet: (Reels) -> Unit,
    onShareReel: (Reels) -> Unit
) {
    if (reelsList.isEmpty()) {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text("No reels available")
        }
        return
    }

    // Compute initial page for target reel.
    // Profile grid passes UserPost.id which equals Reels.postUid (both are the backend post_uid).
    // Reels.id is the product_id — different from post_uid — so we must check both fields.
    val initialPage = if (!targetReelId.isNullOrBlank()) {
        reelsList.indexOfFirst { it.id == targetReelId || it.postUid == targetReelId }
            .takeIf { it >= 0 } ?: 0
    } else 0

    val pagerState = rememberPagerState(
        initialPage = initialPage.coerceIn(0, reelsList.size - 1),
        pageCount = { reelsList.size }
    )
    val currentPage = pagerState.currentPage
    val context = LocalContext.current

    // --- Scroll to target reel ---
    // remember(targetReelId) resets the flag for each new navigation target so a fresh
    // retry is allowed, but we never spin-loop (at most one backend refresh per target).
    var refreshedForTarget by remember(targetReelId) { mutableStateOf(false) }
    LaunchedEffect(targetReelId, reelsList.size) {
        if (!targetReelId.isNullOrBlank() && reelsList.isNotEmpty()) {
            val idx = reelsList.indexOfFirst { it.id == targetReelId || it.postUid == targetReelId }
            if (idx >= 0) {
                pagerState.scrollToPage(idx)
            } else if (!refreshedForTarget) {
                // One retry per target in case the cached feed was stale
                refreshedForTarget = true
                viewModel.refreshDataOnly()
            }
        }
    }

    // --- Scroll to top on new post ---
    LaunchedEffect(Unit) {
        viewModel.scrollToTop.collect {
            if (targetReelId == null && reelsList.isNotEmpty()) {
                pagerState.scrollToPage(0)
            }
        }
    }

    // --- Track current reel + update MainUiState ---
    LaunchedEffect(currentPage, reelsList.size) {
        if (reelsList.isNotEmpty() && currentPage < reelsList.size) {
            val reel = reelsList[currentPage]
            mainUiStateViewModel?.setCurrentReel(reel)
            viewModel.checkCartStatus(reel.id)
            delay(1000)
            if (currentPage < reelsList.size && currentPage == pagerState.currentPage) {
                recentlyViewedViewModel.addReelToRecentlyViewed(reel)
            }
        } else {
            mainUiStateViewModel?.setCurrentReel(null)
        }
    }

    // --- Manage video play states: only current page plays ---
    LaunchedEffect(currentPage, reelsList.size) {
        if (reelsList.isNotEmpty() && currentPage < reelsList.size) {
            val currentReelId = reelsList[currentPage].id
            globalVideoPlayStates.keys.forEach { key ->
                globalVideoPlayStates[key] = false
            }
            globalVideoPlayStates[currentReelId] = true

            // Preload next videos
            val videoUris = reelsList.mapNotNull { it.video }
            VideoPreloader.preloadNextVideos(context, currentPage, videoUris)
        }
    }

    // Cleanup preloader
    DisposableEffect(Unit) {
        onDispose { VideoPreloader.clearAll() }
    }

    // --- Vertical pager ---
    VerticalPager(
        state = pagerState,
        modifier = Modifier.fillMaxSize()
    ) { page ->
        val reel = reelsList[page]
        val isCurrentlyPlaying = globalVideoPlayStates[reel.id] ?: (currentPage == page)

        ReelPage(
            reel = reel,
            page = page,
            isCurrentPage = page == currentPage,
            isPlaying = isCurrentlyPlaying,
            navController = navController,
            viewModel = viewModel,
            cartViewModel = cartViewModel,
            isLoggedIn = isLoggedIn,
            showLoginPrompt = showLoginPrompt,
            globalVideoPlayStates = globalVideoPlayStates,
            trackingRepository = trackingRepository,
            onOpenComments = onOpenComments,
            onOpenBuySheet = onOpenBuySheet,
            onShareReel = onShareReel
        )
    }
}
