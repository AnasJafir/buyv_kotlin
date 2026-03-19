package com.project.e_commerce.android.presentation.ui.screens.reelsScreen
import androidx.compose.foundation.clickable

import android.util.Log
import androidx.compose.foundation.border
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import coil3.compose.AsyncImage
import com.project.e_commerce.android.presentation.ui.navigation.Screens
import com.project.e_commerce.android.presentation.viewModel.CartItemUi
import com.project.e_commerce.android.presentation.viewModel.CartViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * Bottom sheet for purchasing a product from a reel.
 * Shows product image, name, rating, description, quantity selector, and add-to-cart button.
 */
@Composable
fun BuyBottomSheet(
    onClose: () -> Unit = {},
    onShowRatings: () -> Unit = {},
    productPrice: Double = 0.0,
    productImage: String = "",
    reel: Reels? = null,
    cartViewModel: CartViewModel? = null,
    navController: NavController? = null,
    modifier: Modifier = Modifier
) {
    var quantity by remember { mutableStateOf(1) }
    val totalPrice = productPrice * quantity
    var addedToCart by remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()

    val thumbnailUrl = remember(reel) {
        if (reel != null) {
            com.project.e_commerce.android.presentation.utils.VideoThumbnailUtils.getBestThumbnail(
                images = reel.images?.map { it.toString() },
                videoUrl = reel.video?.toString(),
                fallbackUrl = reel.productImage
            )
        } else productImage
    }
    val realName = reel?.productName.orEmpty()
    val realDescription = reel?.contentDescription.orEmpty()
    val averageRating = computeAverageRating(reel)
    val formattedRating = formatRatingValue(averageRating)

    Column(
        modifier = modifier
            .fillMaxWidth()
            .background(Color.White, RoundedCornerShape(topStart = 24.dp, topEnd = 24.dp))
            .heightIn(min = 390.dp, max = 600.dp)
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 16.dp, vertical = 8.dp)
            .imePadding()
    ) {
        // Close button
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
            IconButton(onClick = onClose) {
                Icon(Icons.Default.Close, contentDescription = "Close")
            }
        }

        Spacer(Modifier.height(4.dp))

        // Product image
        if (!thumbnailUrl.isNullOrBlank()) {
            AsyncImage(
                model = thumbnailUrl,
                contentDescription = realName,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(180.dp)
                    .clip(RoundedCornerShape(12.dp)),
                contentScale = ContentScale.Crop
            )
            Spacer(Modifier.height(8.dp))
        }

        // Title
        Text(
            text = realName,
            fontWeight = FontWeight.Bold,
            fontSize = 20.sp,
            textAlign = TextAlign.Center,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(Modifier.height(4.dp))

        // Rating chip
        if (averageRating > 0) {
            Box(
                Modifier
                    .align(Alignment.CenterHorizontally)
                    .background(Color(0xFFFFF8E1), RoundedCornerShape(8.dp))
                    .clickable { onShowRatings() }
                    .padding(horizontal = 12.dp, vertical = 4.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.Star, "Rating", tint = Color(0xFFFFC107), modifier = Modifier.size(16.dp))
                    Spacer(Modifier.width(4.dp))
                    Text(formattedRating, color = Color(0xFFFFC107), fontSize = 14.sp)
                    Spacer(Modifier.width(4.dp))
                    Text("(${reel?.ratings?.size ?: 0} avis)", color = Color.Gray, fontSize = 12.sp)
                }
            }
            Spacer(Modifier.height(4.dp))
        }

        // Description
        if (realDescription.isNotBlank()) {
            Text(
                text = realDescription,
                color = Color.Gray,
                fontSize = 13.sp,
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth(),
                maxLines = 3,
                overflow = TextOverflow.Ellipsis
            )
        }

        Spacer(Modifier.height(12.dp))

        // Price + quantity
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                text = "${totalPrice.toInt()}$",
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFFFF6F00)
            )
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier
                    .height(48.dp)
                    .border(1.dp, Color(0xFF176DBA), RoundedCornerShape(8.dp))
                    .padding(horizontal = 6.dp)
            ) {
                IconButton(onClick = { if (quantity > 1) quantity-- }) {
                    Text("-", fontSize = 24.sp, fontWeight = FontWeight.Bold, color = Color.Black)
                }
                Text(
                    "$quantity",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(horizontal = 4.dp),
                    color = Color(0xFF0B74DA)
                )
                IconButton(onClick = { quantity++ }) {
                    Text("+", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Color.Black)
                }
            }
        }

        Spacer(Modifier.height(16.dp))

        // Add to Cart button
        Button(
            onClick = {
                if (reel != null && cartViewModel != null) {
                    val cartItem = CartItemUi(
                        productId = reel.marketplaceProductId ?: reel.id,
                        name = realName.ifBlank { "Product" },
                        price = productPrice,
                        imageUrl = thumbnailUrl.orEmpty(),
                        quantity = quantity,
                        reelId = reel.id,
                        promoterUid = reel.userId.ifBlank { null }
                    )
                    cartViewModel.addToCart(cartItem)
                    addedToCart = true
                    scope.launch {
                        delay(1500)
                        onClose()
                    }
                }
            },
            modifier = Modifier
                .fillMaxWidth()
                .height(52.dp),
            colors = ButtonDefaults.buttonColors(
                backgroundColor = if (addedToCart) Color(0xFF4CAF50) else Color(0xFFFF6F00)
            ),
            shape = RoundedCornerShape(12.dp),
            enabled = !addedToCart
        ) {
            if (addedToCart) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.Check, null, tint = Color.White)
                    Spacer(Modifier.width(8.dp))
                    Text("Added to Cart!", color = Color.White, fontWeight = FontWeight.Bold)
                }
            } else {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.ShoppingCart, null, tint = Color.White)
                    Spacer(Modifier.width(8.dp))
                    Text("Add to Cart", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                }
            }
        }

        // View Product Details link
        if (navController != null && reel?.marketplaceProductId != null) {
            Spacer(Modifier.height(8.dp))
            TextButton(
                onClick = {
                    onClose()
                    navController.navigate(
                        Screens.Marketplace.ProductDetail.createRoute(reel.marketplaceProductId!!)
                    )
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text(
                    "View Full Product Details",
                    color = Color(0xFF176DBA),
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 14.sp
                )
            }
        }

        Spacer(Modifier.height(8.dp))
    }
}

// --- Utility functions ---

private fun computeAverageRating(reel: Reels?): Double {
    if (reel == null) return 0.0
    if (reel.ratings.isNotEmpty()) {
        val total = reel.ratings.sumOf { it.rate }
        return (total.toDouble() / reel.ratings.size * 10).toInt() / 10.0
    }
    if (reel.rating > 0.1) return reel.rating
    return 0.0
}

private fun formatRatingValue(rating: Double): String {
    return if (rating == 0.0) "0.0" else String.format("%.1f", rating)
}
