package com.project.e_commerce.android.presentation.ui.screens.reelsScreen

import android.util.Log
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.pager.VerticalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.VideoLibrary
import androidx.compose.runtime.*
import androidx.compose.runtime.mutableStateMapOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.snapshots.SnapshotStateMap
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.project.e_commerce.android.presentation.viewModel.CartViewModel
import com.project.e_commerce.android.presentation.viewModel.RecentlyViewedViewModel
import com.project.e_commerce.android.presentation.viewModel.followingViewModel.FollowingViewModel
import com.project.e_commerce.android.presentation.viewModel.reelsScreenViewModel.ReelsScreenViewModel

/**
 * Content for the "Following" tab in the reels screen.
 * Shows reels only from users that the current user follows.
 */
@Composable
fun FollowingReelsContent(
    navController: NavController,
    followingViewModel: FollowingViewModel,
    reelsViewModel: ReelsScreenViewModel,
    cartViewModel: CartViewModel,
    onShowSheet: (SheetType, Reels?) -> Unit,
    onShareReel: (Reels) -> Unit,
    recentlyViewedViewModel: RecentlyViewedViewModel
) {
    val followingState by followingViewModel.uiState.collectAsState()
    val currentUserProvider: com.project.e_commerce.data.local.CurrentUserProvider =
        org.koin.compose.koinInject()
    var currentUserId by remember { mutableStateOf<String?>(null) }
    val followingVideoPlayStates = remember { mutableStateMapOf<String, Boolean>() }

    LaunchedEffect(Unit) {
        currentUserId = currentUserProvider.getCurrentUserId()
    }

    val hasLoaded = rememberSaveable(currentUserId) { mutableStateOf(false) }

    LaunchedEffect(currentUserId) {
        if (!hasLoaded.value && currentUserId != null) {
            followingViewModel.resetLoadAttempts()
            followingViewModel.loadUserData(currentUserId!!, "current_user")
            hasLoaded.value = true
        }
    }

    when {
        followingState.isLoading -> {
            Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        }
        followingState.error?.isNotEmpty() == true -> {
            Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Text(
                    text = "Error: ${followingState.error}",
                    color = Color.Red,
                    textAlign = TextAlign.Center
                )
            }
        }
        followingState.following.isEmpty() -> {
            Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    Icon(Icons.Default.Person, null, Modifier.size(64.dp), tint = Color.Gray)
                    Text(
                        "You're not following anyone yet",
                        style = MaterialTheme.typography.h6,
                        textAlign = TextAlign.Center,
                        color = Color.Gray
                    )
                    Text(
                        "Follow some users to see their reels here",
                        style = MaterialTheme.typography.body2,
                        textAlign = TextAlign.Center,
                        color = Color.Gray
                    )
                }
            }
        }
        else -> {
            val followingUserIds = followingState.following.map { it.id }
            FollowingReelsList(
                navController = navController,
                followingUserIds = followingUserIds,
                reelsViewModel = reelsViewModel,
                cartViewModel = cartViewModel,
                onShowSheet = onShowSheet,
                onShareReel = onShareReel,
                recentlyViewedViewModel = recentlyViewedViewModel,
                globalVideoPlayStates = followingVideoPlayStates
            )
        }
    }
}

/**
 * Vertical pager showing only reels from followed users.
 * Reuses the same [ReelPage] composable as the "For you" tab.
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
private fun FollowingReelsList(
    navController: NavController,
    followingUserIds: List<String>,
    reelsViewModel: ReelsScreenViewModel,
    cartViewModel: CartViewModel,
    onShowSheet: (SheetType, Reels?) -> Unit,
    onShareReel: (Reels) -> Unit,
    recentlyViewedViewModel: RecentlyViewedViewModel,
    globalVideoPlayStates: SnapshotStateMap<String, Boolean>
) {
    val reelsState by reelsViewModel.state.collectAsState()
    val followingReels = reelsViewModel.getReelsFromUsers(followingUserIds)
    val trackingRepository: com.project.e_commerce.android.data.repository.TrackingRepository =
        org.koin.compose.koinInject()
    val showLoginPrompt = remember { mutableStateOf(false) }

    if (followingReels.isEmpty()) {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Icon(Icons.Default.VideoLibrary, null, Modifier.size(64.dp), tint = Color.Gray)
                Text(
                    "No reels from people you follow",
                    style = MaterialTheme.typography.h6,
                    textAlign = TextAlign.Center,
                    color = Color.Gray
                )
                Text(
                    "The people you follow haven't posted any reels yet",
                    style = MaterialTheme.typography.body2,
                    textAlign = TextAlign.Center,
                    color = Color.Gray
                )
            }
        }
        return
    }

    val pagerState = rememberPagerState(
        initialPage = 0,
        pageCount = { followingReels.size }
    )

    VerticalPager(
        state = pagerState,
        modifier = Modifier.fillMaxSize()
    ) { page ->
        val reel = followingReels[page]
        val isPlaying = globalVideoPlayStates[reel.id] ?: (pagerState.currentPage == page)

        ReelPage(
            reel = reel,
            page = page,
            isCurrentPage = page == pagerState.currentPage,
            isPlaying = isPlaying,
            navController = navController,
            viewModel = reelsViewModel,
            cartViewModel = cartViewModel,
            isLoggedIn = true,
            showLoginPrompt = showLoginPrompt,
            globalVideoPlayStates = globalVideoPlayStates,
            trackingRepository = trackingRepository,
            onOpenComments = { /* handled by parent */ },
            onOpenBuySheet = { onShowSheet(SheetType.AddToCart, it) },
            onShareReel = onShareReel
        )
    }

    // Manage play states for following tab
    LaunchedEffect(pagerState.currentPage, followingReels.size) {
        if (followingReels.isNotEmpty() && pagerState.currentPage < followingReels.size) {
            val currentReelId = followingReels[pagerState.currentPage].id
            globalVideoPlayStates.keys.forEach { key ->
                globalVideoPlayStates[key] = false
            }
            globalVideoPlayStates[currentReelId] = true
        }
    }
}
