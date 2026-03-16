package com.project.e_commerce.android.presentation.ui.screens.reelsScreen

import android.util.Log
import androidx.activity.compose.BackHandler
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.VideoLibrary
import androidx.compose.runtime.*
import androidx.compose.runtime.snapshots.SnapshotStateMap
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.compose.LocalLifecycleOwner
import androidx.navigation.NavController
import com.project.e_commerce.android.presentation.ui.navigation.Screens
import com.project.e_commerce.android.presentation.ui.screens.HeaderStyle
import com.project.e_commerce.android.presentation.ui.screens.RequireLoginPrompt
import com.project.e_commerce.android.presentation.viewModel.CartViewModel
import com.project.e_commerce.android.presentation.viewModel.followingViewModel.FollowingViewModel
import com.project.e_commerce.android.presentation.viewModel.reelsScreenViewModel.ReelsScreenViewModel
import com.project.e_commerce.android.presentation.viewModel.RecentlyViewedViewModel
import com.project.e_commerce.android.data.repository.TrackingRepository
import com.project.e_commerce.android.presentation.ui.screens.reelsScreen.components.ReelsTopHeader
import kotlinx.coroutines.launch
import org.koin.androidx.compose.koinViewModel
import org.koin.compose.koinInject

/**
 * Main entry point for the Reels feed screen (TikTok/Instagram style).
 *
 * This composable manages:
 * - Tab switching (For you / Following / Explore)
 * - Global video lifecycle (pause all on background)
 * - Bottom sheets (comments, buy)
 * - Login prompt overlay
 *
 * Media rendering is delegated to [ReelsFeedPager] and [ReelPage].
 */
@OptIn(ExperimentalMaterialApi::class)
@Composable
fun ReelsView(
    navController: NavController,
    viewModel: ReelsScreenViewModel,
    cartViewModel: CartViewModel,
    isLoggedIn: Boolean = true,
    targetReelId: String? = null,
    onShowSheet: (SheetType, Reels?) -> Unit,
    mainUiStateViewModel: com.project.e_commerce.android.presentation.viewModel.MainUiStateViewModel? = null
) {
    val showLoginPrompt = remember { mutableStateOf(false) }
    val recentlyViewedViewModel: RecentlyViewedViewModel = koinViewModel()
    val trackingRepository: TrackingRepository = koinInject()
    val lifecycleOwner = LocalLifecycleOwner.current
    val scope = rememberCoroutineScope()

    // --- Share launcher ---
    val shareLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.StartActivityForResult()
    ) { /* no-op */ }

    // --- State collection ---
    val reelsList by viewModel.state.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val errorMessage by viewModel.errorMessage.collectAsState()

    // --- Global video play states for lifecycle management ---
    val globalVideoPlayStates = remember { mutableStateMapOf<String, Boolean>() }

    // Pause all videos when app goes to background
    DisposableEffect(lifecycleOwner) {
        val observer = LifecycleEventObserver { _, event ->
            when (event) {
                Lifecycle.Event.ON_PAUSE -> {
                    globalVideoPlayStates.keys.forEach { id ->
                        globalVideoPlayStates[id] = false
                    }
                }
                Lifecycle.Event.ON_STOP -> globalVideoPlayStates.clear()
                Lifecycle.Event.ON_RESUME -> {
                    // Refresh feed when user navigates back to this screen
                    scope.launch { viewModel.forceRefreshFromProductViewModel() }
                }
                else -> {}
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose { lifecycleOwner.lifecycle.removeObserver(observer) }
    }

    // --- Current user ---
    val currentUserProvider: com.project.e_commerce.data.local.CurrentUserProvider = koinInject()
    var currentUserId by remember { mutableStateOf("") }

    // --- Bottom sheet state ---
    var showCommentsSheet by remember { mutableStateOf(false) }
    var selectedPostId by remember { mutableStateOf<String?>(null) }
    var showBuySheet by remember { mutableStateOf(false) }
    var currentReel by remember { mutableStateOf<Reels?>(null) }

    // --- Tab state ---
    val tabList = listOf("For you", "Following", "Explore")
    var selectedTab by remember { mutableStateOf("For you") }

    // --- Following data ---
    val followingViewModel: FollowingViewModel = koinViewModel()

    // Back handler for sheets
    BackHandler(enabled = showBuySheet || showCommentsSheet) {
        showBuySheet = false
        showCommentsSheet = false
        mainUiStateViewModel?.showBottomBar()
    }

    // Force refresh on entry
    LaunchedEffect(Unit) {
        if (targetReelId == null) {
            viewModel.forceRefreshFromProductViewModel()
        } else {
            viewModel.refreshDataOnly(targetReelId)
        }
    }

    // Load user ID and following data
    LaunchedEffect(Unit) {
        currentUserId = currentUserProvider.getCurrentUserId() ?: ""
        try {
            val currentUser = currentUserProvider.getCurrentUser()
            if (currentUser != null) {
                val username = currentUser.displayName
                    ?: currentUser.email?.split("@")?.firstOrNull() ?: "user"
                followingViewModel.resetLoadAttempts()
                val state = followingViewModel.uiState.value
                if (!state.isLoading && state.following.isEmpty()) {
                    followingViewModel.loadUserData(currentUser.uid, username)
                }
            }
        } catch (e: Exception) {
            Log.e("ReelsView", "Failed to load following data: ${e.message}")
        }
    }

    // Default to "For you" on enter
    LaunchedEffect(Unit) { selectedTab = "For you" }

    // --- Loading / Error / Empty states ---
    when {
        isLoading -> {
            Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    CircularProgressIndicator(color = Color.White)
                    Spacer(Modifier.height(16.dp))
                    Text("Loading reels...", color = Color.White, fontSize = 16.sp)
                }
            }
            return
        }
        errorMessage != null -> {
            Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Error loading reels", color = Color.Red, fontSize = 18.sp)
                    Text("$errorMessage", color = Color.LightGray, fontSize = 14.sp)
                    Spacer(Modifier.height(16.dp))
                    Button(onClick = { viewModel.forceRefreshFromProductViewModel() }) {
                        Text("Retry", color = Color.White)
                    }
                }
            }
            return
        }
        reelsList.isEmpty() -> {
            Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(Icons.Default.VideoLibrary, null, Modifier.size(64.dp), tint = Color.Gray)
                    Spacer(Modifier.height(16.dp))
                    Text("No reels found", color = Color.White, fontSize = 18.sp)
                    Text("Create or follow users to see reels", color = Color.LightGray, fontSize = 14.sp)
                    Spacer(Modifier.height(16.dp))
                    Button(onClick = { viewModel.forceRefreshFromProductViewModel() }) {
                        Text("Refresh", color = Color.White)
                    }
                }
            }
            return
        }
    }

    // --- Main content ---
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black)
            .imePadding()
    ) {
        when (selectedTab) {
            "Following" -> {
                FollowingReelsContent(
                    navController = navController,
                    followingViewModel = followingViewModel,
                    reelsViewModel = viewModel,
                    cartViewModel = cartViewModel,
                    onShowSheet = { sheetType, reel ->
                        showBuySheet = true
                        currentReel = reel
                    },
                    onShareReel = { reel -> shareReel(reel, shareLauncher) },
                    recentlyViewedViewModel = recentlyViewedViewModel
                )
            }
            "For you" -> {
                ReelsFeedPager(
                    navController = navController,
                    reelsList = reelsList,
                    viewModel = viewModel,
                    cartViewModel = cartViewModel,
                    isLoggedIn = isLoggedIn,
                    showLoginPrompt = showLoginPrompt,
                    targetReelId = targetReelId,
                    globalVideoPlayStates = globalVideoPlayStates,
                    mainUiStateViewModel = mainUiStateViewModel,
                    recentlyViewedViewModel = recentlyViewedViewModel,
                    trackingRepository = trackingRepository,
                    onOpenComments = { reel ->
                        val postId = reel.postUid?.takeIf { it.isNotBlank() } ?: reel.id
                        selectedPostId = postId
                        showCommentsSheet = true
                        mainUiStateViewModel?.hideBottomBar()
                    },
                    onOpenBuySheet = { reel ->
                        if (!isLoggedIn) showLoginPrompt.value = true
                        showBuySheet = true
                        currentReel = reel
                    },
                    onShareReel = { reel -> shareReel(reel, shareLauncher) }
                )
            }
            else -> { /* Explore navigates away */ }
        }

        // --- Buy bottom sheet overlay ---
        if (showBuySheet && currentReel != null) {
            mainUiStateViewModel?.hideBottomBar()
            Box(
                Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = 0.35f))
                    .clickable {
                        showBuySheet = false
                        mainUiStateViewModel?.showBottomBar()
                    }
            )
            BuyBottomSheet(
                reel = currentReel,
                cartViewModel = cartViewModel,
                navController = navController,
                onClose = {
                    showBuySheet = false
                    mainUiStateViewModel?.showBottomBar()
                },
                productPrice = currentReel?.marketplaceProductPrice
                    ?: currentReel?.productPrice?.toDoubleOrNull() ?: 0.0,
                modifier = Modifier.align(Alignment.BottomCenter)
            )
        } else {
            mainUiStateViewModel?.showBottomBar()
        }

        // --- Login prompt ---
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

        // --- Comments sheet ---
        if (showCommentsSheet && selectedPostId != null) {
            Box(
                Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = 0.5f))
                    .clickable {
                        showCommentsSheet = false
                        selectedPostId = null
                        mainUiStateViewModel?.showBottomBar()
                    }
            )
            CommentsSheet(
                postId = selectedPostId!!,
                onDismiss = {
                    showCommentsSheet = false
                    selectedPostId = null
                    mainUiStateViewModel?.showBottomBar()
                }
            )
        }

        // --- Top tab header ---
        ReelsTopHeader(
            onClickSearch = { navController.navigate(Screens.ReelsScreen.SearchReelsAndUsersScreen.route) },
            selectedTab = selectedTab,
            onTabChange = { newTab ->
                if (newTab == "Explore") {
                    navController.navigate(Screens.ReelsScreen.ExploreScreen.route)
                } else {
                    selectedTab = newTab
                }
            },
            onClickExplore = { selectedTab = "Explore" },
            headerStyle = HeaderStyle.TRANSPARENT_WHITE_TEXT,
            modifier = Modifier
        )
    }
}

/** Types of bottom sheet overlays available in the reels screen. */
enum class SheetType { AddToCart, Comments }

// --- Share helper ---
private fun shareReel(
    reel: Reels,
    launcher: androidx.activity.result.ActivityResultLauncher<android.content.Intent>
) {
    val content = buildString {
        append("Check out this amazing product: ${reel.productName}")
        if (reel.productPrice.isNotBlank()) append(" for only ${reel.productPrice}")
        if (reel.contentDescription.isNotBlank()) append("\n\n${reel.contentDescription}")
        if (reel.video != null && reel.video.toString().isNotBlank()) {
            append("\n\nWatch the video: ${reel.video}")
        }
        append("\n\nDownload our app to see more amazing products!")
    }
    val intent = android.content.Intent().apply {
        action = android.content.Intent.ACTION_SEND
        putExtra(android.content.Intent.EXTRA_TEXT, content)
        type = "text/plain"
    }
    launcher.launch(android.content.Intent.createChooser(intent, "Share Reel"))
}
