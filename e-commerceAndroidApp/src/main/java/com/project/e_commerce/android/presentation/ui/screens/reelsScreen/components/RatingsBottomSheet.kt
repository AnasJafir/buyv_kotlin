package com.project.e_commerce.android.presentation.ui.screens.reelsScreen.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Star
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.project.e_commerce.android.presentation.ui.screens.reelsScreen.Reels
import com.project.e_commerce.android.presentation.ui.screens.reelsScreen.Ratings

@Composable
fun RatingsBottomSheet(
    reel: Reels?,
    onDismiss: () -> Unit,
    modifier: Modifier = Modifier
) {
    val ratingsList = reel?.ratings ?: emptyList()
    val totalStars = getAverageRating(ratingsList)
    val formattedRating = if (totalStars > 0) String.format("%.1f", totalStars) else "0.0"

    Column(
        modifier = modifier
            .fillMaxWidth()
            .fillMaxHeight(0.85f)
            .background(
                color = MaterialTheme.colors.surface,
                shape = RoundedCornerShape(topStart = 16.dp, topEnd = 16.dp)
            )
    ) {
        // Header
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    text = "Ratings",
                    style = MaterialTheme.typography.h6,
                    fontWeight = FontWeight.Bold
                )
                if (ratingsList.isNotEmpty()) {
                    Spacer(Modifier.width(8.dp))
                    Icon(Icons.Default.Star, contentDescription = "Star", tint = Color(0xFFFFC107), modifier = Modifier.size(20.dp))
                    Spacer(Modifier.width(4.dp))
                    Text(
                        text = formattedRating,
                        fontWeight = FontWeight.Bold,
                        fontSize = 18.sp
                    )
                    Text(
                        text = " (${ratingsList.size})",
                        color = Color.Gray,
                        fontSize = 14.sp
                    )
                }
            }
            IconButton(onClick = onDismiss) {
                Icon(
                    imageVector = Icons.Default.Close,
                    contentDescription = "Close ratings"
                )
            }
        }

        Divider()

        // Content
        Box(
            modifier = Modifier
                .weight(1f)
                .fillMaxWidth()
        ) {
            if (ratingsList.isEmpty()) {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(32.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.Star,
                        contentDescription = "No ratings",
                        modifier = Modifier.size(48.dp),
                        tint = Color.LightGray
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "No ratings yet",
                        style = MaterialTheme.typography.body1,
                        color = Color.Gray
                    )
                }
            } else {
                LazyColumn(
                    contentPadding = PaddingValues(vertical = 8.dp)
                ) {
                    items(items = ratingsList) { rating ->
                        ModernRatingItem(rating)
                    }
                }
            }
        }
    }
}

@Composable
fun ModernRatingItem(rating: Ratings) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = rating.userName.ifBlank { "Anonymous" },
                fontWeight = FontWeight.Bold,
                fontSize = 14.sp
            )
            Text(
                text = rating.time.ifBlank { "Recently" },
                color = Color.Gray,
                fontSize = 12.sp
            )
        }
        Spacer(modifier = Modifier.height(4.dp))
        Row {
            for (i in 1..5) {
                Icon(
                    imageVector = Icons.Default.Star,
                    contentDescription = null,
                    tint = if (i <= rating.rate) Color(0xFFFFC107) else Color(0xFFE0E0E0),
                    modifier = Modifier.size(16.dp)
                )
            }
        }
        if (rating.review.isNotBlank()) {
            Spacer(modifier = Modifier.height(6.dp))
            Text(
                text = rating.review,
                fontSize = 14.sp,
                color = Color.DarkGray
            )
        }
        Spacer(modifier = Modifier.height(8.dp))
        Divider()
    }
}

fun getAverageRating(ratings: List<Ratings>): Double {
    if (ratings.isEmpty()) return 0.0
    val totalStars = ratings.sumOf { it.rate }
    val averageRating = totalStars.toDouble() / ratings.size
    return (averageRating * 10).toInt() / 10.0
}
