package com.project.e_commerce.android.presentation.ui.navigation

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.material3.Icon as Material3Icon
import androidx.compose.material3.Text as Material3Text
import androidx.compose.material.Icon

@Composable
fun AppBottomBar(
    titles: List<String>,
    icons: List<Int>,
    selectedTab: Int,
    onTabSelected: (Int) -> Unit,
    profileBadgeCount: Int = 0,
    productsBadgeCount: Int = 0,
    showFab: Boolean = false,
    onAddClick: () -> Unit = {}
) {
    Box(
        modifier = Modifier
            .fillMaxWidth(),
        contentAlignment = Alignment.BottomCenter
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(64.dp)
                .clip(RoundedCornerShape(topStart = 28.dp, topEnd = 28.dp))
                .background(Color.White)
        ) {
            Row(
                Modifier
                    .fillMaxWidth()
                    .height(64.dp)
                    .align(Alignment.BottomCenter),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // We assume there are 4 tabs
                TabItem(0, titles, icons, selectedTab, onTabSelected, profileBadgeCount, productsBadgeCount)
                TabItem(1, titles, icons, selectedTab, onTabSelected, profileBadgeCount, productsBadgeCount)
                
                // Placeholder space for the middle Add Button
                Spacer(modifier = Modifier.width(56.dp))
                
                TabItem(2, titles, icons, selectedTab, onTabSelected, profileBadgeCount, productsBadgeCount)
                TabItem(3, titles, icons, selectedTab, onTabSelected, profileBadgeCount, productsBadgeCount)
            }
        }
        
        // Central Add Button overlapping the bar
        Box(
            modifier = Modifier
                .align(Alignment.TopCenter)
                .offset(y = (-14).dp)
                .size(52.dp)
                .shadow(8.dp, CircleShape)
                .background(
                    brush = Brush.horizontalGradient(listOf(Color(0xFFf8a714), Color(0xFFed380a))),
                    shape = CircleShape
                )
                .clickable { onAddClick() },
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = Icons.Filled.Add,
                contentDescription = "Upload Content",
                tint = Color.White,
                modifier = Modifier.size(32.dp)
            )
        }
    }
}

@Composable
fun RowScope.TabItem(
    index: Int,
    titles: List<String>,
    icons: List<Int>,
    selectedTab: Int,
    onTabSelected: (Int) -> Unit,
    profileBadgeCount: Int,
    productsBadgeCount: Int
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier
            .weight(1f)
            .clickable(
                indication = null,
                interactionSource = remember { MutableInteractionSource() }
            ) {
                onTabSelected(index)
            }
    ) {
        Box(contentAlignment = Alignment.Center, modifier = Modifier.size(24.dp)) {
            if (icons.getOrNull(index) != null) {
                Material3Icon(
                    painter = painterResource(id = icons[index]),
                    contentDescription = null,
                    tint = if (selectedTab == index) Color(0xFFFF6F00) else Color(0xD8000000),
                    modifier = Modifier.size(20.dp)
                )
            }
            
            // Profile badge logic
            if (index == 3 && profileBadgeCount > 0) {
                Box(modifier = Modifier.size(10.dp).offset(x = 8.dp, y = (-8).dp).background(Color.Red, shape = CircleShape))
            }
            // Products badge logic
            if (index == 1 && productsBadgeCount > 0) {
                Box(modifier = Modifier.size(10.dp).offset(x = 8.dp, y = (-8).dp).background(Color.Red, shape = CircleShape))
            }
        }
        Material3Text(
            text = titles.getOrNull(index) ?: "",
            fontSize = 10.sp,
            fontWeight = if (selectedTab == index) FontWeight.Bold else FontWeight.Normal,
            color = if (selectedTab == index) Color(0xFFFF6F00) else Color(0xD8000000),
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(top = 2.dp)
        )
    }
}
