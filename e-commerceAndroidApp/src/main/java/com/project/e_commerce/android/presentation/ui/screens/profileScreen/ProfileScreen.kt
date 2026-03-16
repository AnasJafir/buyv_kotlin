package com.project.e_commerce.android.presentation.ui.screens.profileScreen

import android.net.Uri
import android.util.Log
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavHostController
import coil3.compose.AsyncImage
import com.project.e_commerce.android.R
import com.project.e_commerce.android.domain.model.UserPost
import com.project.e_commerce.android.domain.model.UserProduct
import com.project.e_commerce.android.presentation.ui.composable.composableScreen.public.VideoThumbnail
import com.project.e_commerce.android.presentation.ui.navigation.Screens
import com.project.e_commerce.android.presentation.ui.screens.RequireLoginPrompt
import com.project.e_commerce.android.presentation.utils.CloudinaryUtils
import com.project.e_commerce.android.presentation.utils.UserInfoCache
import com.project.e_commerce.android.presentation.utils.VideoThumbnailUtils
import com.project.e_commerce.android.presentation.viewModel.CartItemUi
import com.project.e_commerce.android.presentation.viewModel.CartViewModel
import com.project.e_commerce.android.presentation.viewModel.ProductViewModel
import com.project.e_commerce.android.presentation.viewModel.profileViewModel.DeletePostState
import com.project.e_commerce.android.presentation.viewModel.profileViewModel.ProfileViewModel
import org.koin.androidx.compose.koinViewModel

private const val TAG = "ProfileScreen"

// ───────────────────────────────────────────────────────────
// Main entry point
// ───────────────────────────────────────────────────────────

@Composable
fun ProfileScreen(navController: NavHostController) {
    val profileViewModel: ProfileViewModel = koinViewModel()
    val uiState by profileViewModel.uiState.collectAsState()
    val userReels by profileViewModel.userReels.collectAsState()
    val userProducts by profileViewModel.userProducts.collectAsState()
    val userLikedContent by profileViewModel.userLikedContent.collectAsState()
    val userBookmarkedContent by profileViewModel.userBookmarkedContent.collectAsState()
    val deletePostState by profileViewModel.deletePostState.collectAsState()
    val cartViewModel: CartViewModel = koinViewModel()
    val cartState by cartViewModel.state.collectAsState()

    // Refresh following data + cart on mount
    LaunchedEffect(Unit) {
        profileViewModel.refreshFollowingData()
        cartViewModel.initializeCart()
    }

    // Refresh profile when returning from other screens (e.g. EditProfile)
    LaunchedEffect(navController.currentBackStackEntry) {
        profileViewModel.refreshProfile()
        UserInfoCache.clearAllCache()
    }

    // Error dialog
    if (uiState.error != null) {
        AlertDialog(
            onDismissRequest = { profileViewModel.clearError() },
            title = { Text("Error") },
            text = { Text(uiState.error!!) },
            confirmButton = { TextButton(onClick = { profileViewModel.clearError() }) { Text("OK") } }
        )
    }

    // Delete post state feedback
    when (val state = deletePostState) {
        is DeletePostState.Success -> LaunchedEffect(state) { profileViewModel.resetDeletePostState() }
        is DeletePostState.Error -> AlertDialog(
            onDismissRequest = { profileViewModel.resetDeletePostState() },
            title = { Text("Deletion error") },
            text = { Text(state.message) },
            confirmButton = { TextButton(onClick = { profileViewModel.resetDeletePostState() }) { Text("OK") } }
        )
        else -> { /* Idle/Loading */ }
    }

    // Auth check
    val isNotAuthenticated = uiState.displayName.isEmpty() &&
            !uiState.isLoading &&
            (uiState.error?.contains("not authenticated", ignoreCase = true) == true ||
                    uiState.error?.contains("Unauthorized", ignoreCase = true) == true ||
                    uiState.error?.contains("not logged", ignoreCase = true) == true)

    if (isNotAuthenticated) {
        RequireLoginPrompt(
            onLogin = { navController.navigate(Screens.LoginScreen.route) },
            onSignUp = { navController.navigate(Screens.LoginScreen.CreateAccountScreen.route) },
            onDismiss = { /* nothing */ },
            showCloseButton = false
        )
        return
    }

    // Tab state
    var selectedTabIndex by remember { mutableStateOf(0) }
    val tabs = listOf(
        Pair(R.drawable.ic_reels, R.drawable.ic_reels),
        Pair(R.drawable.ic_products_filled, R.drawable.ic_products),
        Pair(R.drawable.ic_save_filled, R.drawable.ic_save),
        Pair(R.drawable.ic_love_checked, R.drawable.ic_heart_outlined)
    )

    if (uiState.isLoading) {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            CircularProgressIndicator(color = Color(0xFFFF6F00), modifier = Modifier.size(48.dp))
        }
    } else {
        Box(modifier = Modifier.fillMaxSize()) {
            LazyColumn(
                modifier = Modifier.fillMaxSize().background(Color.White),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // Top bar
                item {
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(top = 6.dp, start = 4.dp, end = 4.dp),
                        horizontalArrangement = Arrangement.End,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(horizontalArrangement = Arrangement.End, verticalAlignment = Alignment.CenterVertically) {
                            IconButton(onClick = { navController.navigate(Screens.PromoterDashboard.route) }) {
                                Icon(painterResource(R.drawable.ic_card), "Wallet", tint = Color(0xFFFF6F00), modifier = Modifier.size(28.dp))
                            }
                            IconButton(onClick = { navController.navigate(Screens.ProfileScreen.SettingsScreen.route) }) {
                                Icon(painterResource(R.drawable.ic_menu), "Menu", tint = Color(0xFFFF6F00), modifier = Modifier.padding(7.dp))
                            }
                        }
                    }
                }

                item { Spacer(Modifier.height(8.dp)) }

                // Stats + Profile Image
                item {
                    Box(
                        modifier = Modifier.fillMaxWidth().padding(horizontal = 32.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceEvenly,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            ProfileStat(uiState.followingCount.toString(), "Following") {
                                navigateToFollowList(navController, uiState.username, startTab = 1)
                            }

                            ProfileAvatar(profileImageUrl = uiState.profileImageUrl)

                            ProfileStat(uiState.followersCount.toString(), "Followers") {
                                navigateToFollowList(navController, uiState.username, startTab = 0)
                            }
                        }
                    }
                    Spacer(Modifier.height(8.dp))
                }

                // Name & Username
                item {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(uiState.displayName.ifEmpty { "User" }, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Color(0xFF0D3D67))
                        Spacer(Modifier.width(4.dp))
                    }
                    Text("@${uiState.username.ifEmpty { "user" }}", fontSize = 13.sp, color = Color.Gray)
                    Spacer(Modifier.height(8.dp))
                }

                item { ProfileStat(uiState.likesCount.toString(), "Likes") }
                item { Spacer(Modifier.height(16.dp)) }

                // Edit / Share buttons
                item {
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(horizontal = 60.dp),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        Button(
                            onClick = { navController.navigate(Screens.ProfileScreen.EditProfileScreen.route) },
                            colors = ButtonDefaults.buttonColors(backgroundColor = Color(0xFF176DBA)),
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier.weight(1f).height(42.dp)
                        ) { Text("Edit Profile", color = Color.White, fontWeight = FontWeight.SemiBold) }

                        Button(
                            onClick = { /* Share */ },
                            colors = ButtonDefaults.buttonColors(backgroundColor = Color(0xFFf2f2f2)),
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier.weight(1f).height(42.dp)
                        ) { Text("Share Profile", color = Color.Black, fontWeight = FontWeight.SemiBold) }
                    }
                }

                item { Spacer(Modifier.height(12.dp)) }

                // Add New Post button
                item {
                    Button(
                        onClick = { navController.navigate(Screens.ProfileScreen.AddNewContentScreen.route) },
                        colors = ButtonDefaults.buttonColors(backgroundColor = Color(0xFFFF6F00)),
                        shape = RoundedCornerShape(8.dp),
                        modifier = Modifier.fillMaxWidth().padding(horizontal = 60.dp).height(42.dp),
                        elevation = ButtonDefaults.elevation(defaultElevation = 4.dp)
                    ) { Text("+ Add New Post", fontSize = 15.sp, color = Color.White, fontWeight = FontWeight.Bold) }
                }

                item { Spacer(Modifier.height(8.dp)) }
                item { Spacer(Modifier.height(20.dp)) }

                // Tab row
                item {
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceAround) {
                        tabs.forEachIndexed { index, (filledIcon, outlineIcon) ->
                            IconButton(onClick = { selectedTabIndex = index }, modifier = Modifier.size(34.dp)) {
                                Icon(
                                    painterResource(if (selectedTabIndex == index) filledIcon else outlineIcon),
                                    null,
                                    tint = if (selectedTabIndex == index) Color(0xFFFF6F00) else Color.Gray,
                                    modifier = Modifier.size(if (index == 0) 30.dp else 20.dp)
                                )
                            }
                        }
                    }
                }

                item { Spacer(Modifier.height(16.dp)) }

                // Content grid for selected tab
                item {
                    when (selectedTabIndex) {
                        0 -> ProfileReelsGrid(
                            reels = userReels,
                            navController = navController,
                            onDeletePost = { profileViewModel.deletePost(it) },
                            isDeleting = deletePostState is DeletePostState.Loading
                        )
                        1 -> UserProductsGrid(userProducts, navController)
                        2 -> if (userBookmarkedContent.isNotEmpty()) {
                            UserPostGrid(userBookmarkedContent, navController, "No saved posts yet", "Save posts and products to see them here")
                        } else {
                            UserCartBookmarkGrid(cartState.items, navController)
                        }
                        3 -> UserPostGrid(userLikedContent, navController, "No likes yet", "Like posts and products to see them here")
                    }
                }
            }
        }
    }
}

// ───────────────────────────────────────────────────────────
// Private helper composables
// ───────────────────────────────────────────────────────────

@Composable
private fun ProfileAvatar(profileImageUrl: String?) {
    if (!profileImageUrl.isNullOrBlank()) {
        val normalizedUrl = CloudinaryUtils.normalizeCloudinaryUrl(profileImageUrl)
        AsyncImage(
            model = normalizedUrl,
            contentDescription = "Profile Picture",
            modifier = Modifier.size(100.dp).clip(CircleShape),
            contentScale = ContentScale.Crop,
            placeholder = painterResource(R.drawable.profile),
            error = painterResource(R.drawable.profile)
        )
    } else {
        Image(
            painterResource(R.drawable.profile),
            "Profile Picture",
            modifier = Modifier.size(100.dp).clip(CircleShape)
        )
    }
}

private fun navigateToFollowList(navController: NavHostController, username: String, startTab: Int) {
    try {
        val route = Screens.FollowListScreen.createRoute(username = username, startTab = startTab, showFriendsTab = true)
        navController.navigate(route)
    } catch (e: Exception) {
        Log.e(TAG, "Navigation to FollowList failed: ${e.message}")
    }
}

// ───────────────────────────────────────────────────────────
// Public composables used by this file + UserProfileScreen
// ───────────────────────────────────────────────────────────

@Composable
fun ProfileStat(number: String, label: String, onClick: () -> Unit = {}) {
    Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.clickable(onClick = onClick)) {
        Text(number, color = Color(0xFF0D3D67), fontWeight = FontWeight.Bold, fontSize = 18.sp)
        Text(label, fontSize = 14.sp, color = Color.Gray)
    }
}

// ───────────────────────────────────────────────────────────
// Reels Grid (tab 0)
// ───────────────────────────────────────────────────────────

@Composable
fun ProfileReelsGrid(
    reels: List<UserPost>,
    navController: NavHostController,
    onDeletePost: (String) -> Unit = {},
    isDeleting: Boolean = false
) {
    var postToDelete by remember { mutableStateOf<String?>(null) }

    // Delete confirmation dialog
    if (postToDelete != null) {
        AlertDialog(
            onDismissRequest = { postToDelete = null },
            title = { Text("Delete this post?") },
            text = { Text("This action is irreversible. Are you sure you want to delete this post?") },
            confirmButton = {
                TextButton(onClick = { postToDelete?.let { onDeletePost(it) }; postToDelete = null }, enabled = !isDeleting) {
                    if (isDeleting) CircularProgressIndicator(Modifier.size(16.dp), Color(0xFFFF6F00), strokeWidth = 2.dp)
                    else Text("Delete", color = Color.Red)
                }
            },
            dismissButton = { TextButton(onClick = { postToDelete = null }) { Text("Cancel") } }
        )
    }

    if (reels.isEmpty()) {
        EmptyStateGrid("No reels yet", "Start creating reels to see them here")
        return
    }

    LazyVerticalGrid(
        columns = GridCells.Fixed(3),
        modifier = Modifier.height(650.dp),
        horizontalArrangement = Arrangement.spacedBy(4.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        items(reels, key = { it.id }) { reel ->
            Box(
                modifier = Modifier
                    .background(Color(0xFFF8F8F8))
                    .aspectRatio(9f / 16f)
                    .clickable { navController.navigate("${Screens.ReelsScreen.route}/${reel.id}") }
            ) {
                // Thumbnail: best image → video thumbnail → empty state
                val bestThumbnail = VideoThumbnailUtils.getBestThumbnail(
                    images = reel.images,
                    videoUrl = reel.mediaUrl,
                    fallbackUrl = reel.thumbnailUrl
                )

                when {
                    !bestThumbnail.isNullOrBlank() -> {
                        AsyncImage(
                            model = bestThumbnail,
                            contentDescription = "Reel thumbnail",
                            contentScale = ContentScale.Crop,
                            modifier = Modifier.fillMaxSize(),
                            error = painterResource(R.drawable.img_2)
                        )
                    }
                    !reel.mediaUrl.isNullOrBlank() -> {
                        VideoThumbnail(
                            videoUri = Uri.parse(reel.mediaUrl),
                            fallbackImageRes = R.drawable.img_2,
                            modifier = Modifier.fillMaxSize(),
                            showPlayIcon = false
                        )
                    }
                    else -> {
                        Box(Modifier.fillMaxSize().background(Color(0xFFE0E0E0))) {
                            Icon(painterResource(R.drawable.ic_play), "No thumbnail", tint = Color.Gray, modifier = Modifier.align(Alignment.Center).size(48.dp))
                        }
                    }
                }

                // Play icon overlay (single unified overlay)
                Box(Modifier.fillMaxSize().background(Color.Black.copy(alpha = 0.3f))) {
                    Icon(painterResource(R.drawable.ic_play), "Play reel", tint = Color.White, modifier = Modifier.align(Alignment.Center).size(32.dp))
                }

                // Views count at bottom
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.align(Alignment.BottomStart).fillMaxWidth().padding(4.dp)
                ) {
                    Icon(painterResource(R.drawable.ic_play), null, tint = Color.White, modifier = Modifier.size(16.dp))
                    Spacer(Modifier.width(4.dp))
                    Text(reel.viewsCount.toString(), color = Color.White, fontSize = 10.sp, fontWeight = FontWeight.Medium)
                }

                // Delete button
                IconButton(
                    onClick = { postToDelete = reel.id },
                    modifier = Modifier.align(Alignment.TopEnd).size(28.dp).padding(2.dp)
                ) {
                    Icon(painterResource(R.drawable.ic_delete), "Delete reel", tint = Color.White, modifier = Modifier.size(18.dp))
                }
            }
        }
    }
}

// ───────────────────────────────────────────────────────────
// Products Grid (tab 1)
// ───────────────────────────────────────────────────────────

@Composable
fun UserProductsGrid(products: List<UserProduct>, navController: NavHostController) {
    if (products.isEmpty()) {
        EmptyStateGrid("No products yet", "Start adding products to see them here")
        return
    }

    LazyVerticalGrid(
        columns = GridCells.Fixed(3),
        modifier = Modifier.height(650.dp),
        horizontalArrangement = Arrangement.spacedBy(4.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        items(products) { product ->
            Column(modifier = Modifier.background(Color(0xFFF8F8F8)).padding(bottom = 4.dp)) {
                Box(Modifier.fillMaxWidth().height(120.dp)) {
                    if (product.images.isNotEmpty()) {
                        AsyncImage(
                            model = product.images.first(),
                            contentDescription = null,
                            contentScale = ContentScale.Crop,
                            modifier = Modifier.fillMaxSize(),
                            error = painterResource(R.drawable.img_2)
                        )
                    } else {
                        Image(painterResource(R.drawable.img_2), null, contentScale = ContentScale.Crop, modifier = Modifier.fillMaxSize())
                    }
                }
                Text(product.name, fontWeight = FontWeight.Bold, fontSize = 13.sp, modifier = Modifier.padding(top = 6.dp, start = 8.dp, end = 8.dp))
                Row(
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 8.dp, vertical = 2.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        if (product.stockQuantity > 0) "${product.stockQuantity} left" else "Out of Stock",
                        color = if (product.stockQuantity > 0) Color(0xFF22C55E) else Color(0xFFEB1919),
                        fontSize = 12.sp
                    )
                    Text("$${product.price}", color = Color(0xFFFF6F00), fontWeight = FontWeight.Bold, fontSize = 13.sp)
                }
            }
        }
    }
}

// ───────────────────────────────────────────────────────────
// Cart Bookmark Grid (tab 2 fallback)
// ───────────────────────────────────────────────────────────

@Composable
fun UserCartBookmarkGrid(cartItems: List<CartItemUi>, navController: NavHostController) {
    val productViewModel: ProductViewModel = koinViewModel()
    val allProducts = productViewModel.allProducts

    if (cartItems.isEmpty()) {
        EmptyStateGrid("No saved items yet", "Add items to your favorites and they will show here.")
        return
    }

    LazyVerticalGrid(
        columns = GridCells.Fixed(3),
        modifier = Modifier.height(650.dp),
        horizontalArrangement = Arrangement.spacedBy(4.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        items(cartItems) { item ->
            val associatedProduct = allProducts.find { it.id == item.productId }
            val hasVideoReel = associatedProduct?.reelVideoUrl?.isNotBlank() == true

            Box(
                modifier = Modifier
                    .background(Color(0xFFF8F8F8))
                    .height(130.dp)
                    .clickable {
                        if (hasVideoReel) {
                            navController.navigate("${Screens.ReelsScreen.route}/${item.productId}")
                        } else {
                            val found = allProducts.find { it.id == item.productId }
                            if (found != null) productViewModel.selectedProduct = found
                            navController.navigate("details_screen/${item.productId}")
                        }
                    }
            ) {
                if (hasVideoReel && !associatedProduct?.reelVideoUrl.isNullOrBlank()) {
                    VideoThumbnail(
                        videoUri = Uri.parse(associatedProduct!!.reelVideoUrl),
                        fallbackImageRes = R.drawable.img_2,
                        modifier = Modifier.fillMaxSize(),
                        showPlayIcon = false
                    )
                    Box(Modifier.fillMaxSize().background(Color.Black.copy(alpha = 0.3f))) {
                        Icon(painterResource(R.drawable.ic_play), "Play video", tint = Color.White, modifier = Modifier.align(Alignment.Center).size(32.dp))
                    }
                } else if (item.imageUrl.isNotBlank()) {
                    AsyncImage(model = item.imageUrl, contentDescription = null, contentScale = ContentScale.Crop, modifier = Modifier.fillMaxSize(), error = painterResource(R.drawable.img_2))
                } else {
                    Image(painterResource(R.drawable.img_2), null, contentScale = ContentScale.Crop, modifier = Modifier.fillMaxSize())
                }
            }
        }
    }
}

// ───────────────────────────────────────────────────────────
// Unified Post Grid — replaces duplicate UserBookmarkedGrid / UserLikedGrid
// ───────────────────────────────────────────────────────────

@Composable
fun UserPostGrid(
    posts: List<UserPost>,
    navController: NavHostController,
    emptyTitle: String,
    emptySubtitle: String
) {
    if (posts.isEmpty()) {
        EmptyStateGrid(emptyTitle, emptySubtitle)
        return
    }

    LazyVerticalGrid(
        columns = GridCells.Fixed(3),
        modifier = Modifier.height(650.dp),
        horizontalArrangement = Arrangement.spacedBy(4.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        items(posts) { post ->
            Box(
                modifier = Modifier
                    .background(Color(0xFFF8F8F8))
                    .height(130.dp)
                    .clickable { navController.navigate("${Screens.ReelsScreen.route}/${post.id}") }
            ) {
                when {
                    !post.mediaUrl.isNullOrBlank() -> {
                        VideoThumbnail(
                            videoUri = Uri.parse(post.mediaUrl),
                            fallbackImageRes = R.drawable.img_2,
                            modifier = Modifier.fillMaxSize(),
                            showPlayIcon = false
                        )
                    }
                    post.images.isNotEmpty() -> {
                        AsyncImage(
                            model = post.images.first(),
                            contentDescription = "Post image",
                            contentScale = ContentScale.Crop,
                            modifier = Modifier.fillMaxSize(),
                            error = painterResource(R.drawable.img_2)
                        )
                    }
                    !post.thumbnailUrl.isNullOrBlank() -> {
                        AsyncImage(
                            model = post.thumbnailUrl,
                            contentDescription = "Post thumbnail",
                            contentScale = ContentScale.Crop,
                            modifier = Modifier.fillMaxSize(),
                            error = painterResource(R.drawable.img_2)
                        )
                    }
                    else -> {
                        Image(painterResource(R.drawable.img_2), "Fallback image", contentScale = ContentScale.Crop, modifier = Modifier.fillMaxSize())
                    }
                }

                // Video play icon overlay
                if (!post.mediaUrl.isNullOrBlank()) {
                    Box(Modifier.fillMaxSize().background(Color.Black.copy(alpha = 0.3f))) {
                        Icon(painterResource(R.drawable.ic_play), "Play video", tint = Color.White, modifier = Modifier.align(Alignment.Center).size(32.dp))
                    }
                }
            }
        }
    }
}

// ───────────────────────────────────────────────────────────
// Empty state
// ───────────────────────────────────────────────────────────

@Composable
fun EmptyStateGrid(title: String, subtitle: String) {
    Box(modifier = Modifier.fillMaxWidth().height(200.dp), contentAlignment = Alignment.Center) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(title, fontSize = 16.sp, fontWeight = FontWeight.Medium, color = Color.Gray)
            Text(subtitle, fontSize = 13.sp, color = Color.LightGray, modifier = Modifier.padding(top = 4.dp))
        }
    }
}
