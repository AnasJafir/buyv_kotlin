package com.project.e_commerce.android.presentation.ui.screens

import android.media.MediaMetadataRetriever
import android.net.Uri
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.MusicNote
import androidx.compose.material3.Icon
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavHostController
import coil3.compose.AsyncImage
import com.project.e_commerce.android.R
import com.project.e_commerce.android.presentation.ui.screens.marketplace.components.ProductSelectionBottomSheet
import com.project.e_commerce.android.presentation.viewModel.addContent.AddNewContentViewModel
import com.project.e_commerce.android.presentation.viewModel.addContent.CategoryBehavior
import org.koin.androidx.compose.koinViewModel

/**
 * Screen for creating new content (reels / photo posts).
 *
 * All business logic (upload, save) is delegated to [AddNewContentViewModel].
 * This composable is pure UI — form fields, media pickers, and submit button.
 */
@Composable
fun AddNewContentScreen(
    navController: NavHostController,
    preSelectedProductId: String? = null,
    preSelectedSoundUid: String? = null,
    onPostCreated: (() -> Unit)? = null
) {
    val viewModel: AddNewContentViewModel = koinViewModel()
    val formState by viewModel.formState.collectAsState()
    val uploadState by viewModel.uploadState.collectAsState()
    val context = LocalContext.current

    // Pre-load product / sound from navigation args
    LaunchedEffect(preSelectedProductId) {
        if (preSelectedProductId != null && formState.selectedMarketplaceProduct == null) {
            viewModel.loadPreSelectedProduct(preSelectedProductId)
        }
    }
    LaunchedEffect(preSelectedSoundUid) {
        if (preSelectedSoundUid != null) viewModel.setSoundUid(preSelectedSoundUid)
    }

    // Media pickers
    val reelLauncher = rememberLauncherForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
        viewModel.setReelVideoUri(uri)
    }
    val imageLauncher = rememberLauncherForActivityResult(ActivityResultContracts.GetMultipleContents()) { uris ->
        if (uris.isNotEmpty()) viewModel.addImageUris(uris)
    }

    val categoryBehavior = AddNewContentViewModel.CATEGORY_BEHAVIORS[formState.selectedCategory]
        ?: CategoryBehavior(emptyList(), false, false)

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.White)
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
            .imePadding()
    ) {
        // ─── Header ───
        ScreenHeader(
            title = if (formState.selectedMarketplaceProduct != null) "Promote Product" else "Add New Product",
            onBack = { navController.popBackStack() }
        )

        Spacer(Modifier.height(16.dp))

        // ─── Sound chip ───
        if (formState.activeSoundUid != null) {
            SoundChip(onRemove = { viewModel.setSoundUid(null) })
            Spacer(Modifier.height(12.dp))
        }

        var isVideoMode by remember { mutableStateOf(true) }

        // UPLOAD-003: Zones séparées
        Row(
            modifier = Modifier.fillMaxWidth().padding(bottom = 16.dp),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            Button(
                onClick = { isVideoMode = true },
                colors = ButtonDefaults.buttonColors(backgroundColor = if (isVideoMode) Color(0xFFFF6F00) else Color.LightGray),
                modifier = Modifier.weight(1f).padding(end = 8.dp)
            ) { Text("Reel Video", color = Color.White) }
            Button(
                onClick = { isVideoMode = false },
                colors = ButtonDefaults.buttonColors(backgroundColor = if (!isVideoMode) Color(0xFFFF6F00) else Color.LightGray),
                modifier = Modifier.weight(1f).padding(start = 8.dp)
            ) { Text("Photos", color = Color.White) }
        }

        if (isVideoMode) {
        // ─── Upload Reel ───
        Text("🎬 Upload Product Reel", fontWeight = FontWeight.SemiBold, color = Color(0xFFFF6F00))
        Spacer(Modifier.height(8.dp))

        if (formState.reelVideoUri != null) {
            VideoPreviewWithTitle(
                videoUri = formState.reelVideoUri!!,
                reelTitle = formState.reelTitle,
                onTitleChange = viewModel::updateReelTitle,
                onRemoveVideo = { viewModel.setReelVideoUri(null) }
            )
            Spacer(Modifier.height(16.dp))
        } else {
            UploadBox(
                height = 160.dp,
                text = "Upload video",
                buttonText = "Browse files",
                note = "Max 60 seconds, MP4/MOV, Max size 50MB",
                onClick = { reelLauncher.launch("video/*") }
            )
        }
        } else {

        Spacer(Modifier.height(16.dp))

        // ─── Upload Images ───
        Text("🖼️ Upload Product Images", fontWeight = FontWeight.SemiBold, color = Color(0xFFFF6F00))
        Spacer(Modifier.height(8.dp))

        if (formState.productImageUris.isNotEmpty()) {
            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                items(formState.productImageUris.size, key = { formState.productImageUris[it].toString() }) { index ->
                    SelectedImage(uri = formState.productImageUris[index], onRemove = { viewModel.removeImageAt(index) })
                }
                item {
                    Button(
                        onClick = { imageLauncher.launch("image/*") },
                        colors = ButtonDefaults.buttonColors(backgroundColor = Color(0xFFFF6F00)),
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier.padding(vertical = 25.dp)
                    ) { Text("+ Add", color = Color.White, fontSize = 12.sp) }
                }
            }
        } else {
            UploadBox(
                height = 160.dp,
                text = "Upload photos",
                buttonText = "Browse files",
                note = "Format: .jpeg, .png & Max file size: 25 MB",
                onClick = { imageLauncher.launch("image/*") }
            )
        }
        }

        Spacer(Modifier.height(16.dp))

        // ─── Description / Caption ───
        CustomOutlinedTextField(
            value = formState.description,
            onValueChange = viewModel::updateDescription,
            label = if (formState.selectedMarketplaceProduct != null) "Your Caption" else "Description",
            placeholder = if (formState.selectedMarketplaceProduct != null) "Add a caption for your reel..." else "Add description",
            minLines = 4
        )
        Spacer(Modifier.height(8.dp))

        // ─── Product detail fields (only when no marketplace product selected) ───
        if (formState.selectedMarketplaceProduct == null) {
            ProductDetailFields(
                formState = formState,
                categoryBehavior = categoryBehavior,
                viewModel = viewModel
            )
        }

        // ─── Marketplace Product Selection ───
        MarketplaceProductSection(
            product = formState.selectedMarketplaceProduct,
            onSelectProduct = { viewModel.setShowProductSheet(true) }
        )

        Spacer(Modifier.height(30.dp))

        // ─── Upload Progress ───
        if (uploadState.isUploading) {
            Column(
                modifier = Modifier.fillMaxWidth().padding(bottom = 12.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                LinearProgressIndicator(
                    modifier = Modifier.fillMaxWidth(),
                    color = Color(0xFFFF6F00),
                    backgroundColor = Color(0xFFFFE0B2)
                )
                Spacer(Modifier.height(6.dp))
                Text(uploadState.step.ifBlank { "Uploading..." }, color = Color(0xFF555555), fontSize = 13.sp)
            }
        }

        // ─── Submit Button ───
        Button(
            onClick = { viewModel.submit(context, onPostCreated) },
            enabled = !uploadState.isUploading,
            modifier = Modifier.fillMaxWidth().height(50.dp),
            shape = RoundedCornerShape(8.dp),
            colors = ButtonDefaults.buttonColors(
                backgroundColor = if (uploadState.isUploading) Color(0xFFBBBBBB) else Color(0xFFFF6F00),
                disabledBackgroundColor = Color(0xFFBBBBBB)
            ),
            elevation = ButtonDefaults.elevation(defaultElevation = 4.dp)
        ) {
            if (uploadState.isUploading) {
                CircularProgressIndicator(modifier = Modifier.size(20.dp), color = Color.White, strokeWidth = 2.dp)
                Spacer(Modifier.width(8.dp))
            }
            Text(
                if (uploadState.isUploading) "Uploading..." else "Submit",
                color = Color.White,
                fontWeight = FontWeight.Bold
            )
        }

        Spacer(Modifier.height(48.dp))
    }

    // ─── Product Selection Bottom Sheet ───
    if (formState.showProductSelectionSheet) {
        ProductSelectionBottomSheet(
            onDismiss = { viewModel.setShowProductSheet(false) },
            onProductSelected = { product ->
                viewModel.setMarketplaceProduct(product)
                viewModel.setShowProductSheet(false)
                Toast.makeText(context, "Product selected: ${product.name}", Toast.LENGTH_SHORT).show()
            }
        )
    }
}

// ──────────────────────────────────────────────────────
// Private section composables
// ──────────────────────────────────────────────────────

@Composable
private fun ScreenHeader(title: String, onBack: () -> Unit) {
    Box(Modifier.fillMaxWidth().height(48.dp)) {
        androidx.compose.material3.IconButton(
            onClick = onBack,
            modifier = Modifier.align(Alignment.CenterStart).offset(x = (-20).dp)
        ) {
            Icon(
                painter = painterResource(id = R.drawable.ic_back),
                contentDescription = "Back",
                tint = Color(0xFF0066CC),
                modifier = Modifier.padding(10.dp)
            )
        }
        Text(
            text = title,
            fontWeight = FontWeight.Bold,
            fontSize = 20.sp,
            color = Color(0xFF0066CC),
            modifier = Modifier.align(Alignment.Center),
            textAlign = TextAlign.Center
        )
    }
}

@Composable
private fun SoundChip(onRemove: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .background(Color(0xFFFFF3E0), RoundedCornerShape(8.dp))
            .padding(horizontal = 12.dp, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(Icons.Default.MusicNote, null, tint = Color(0xFFFF6F00), modifier = Modifier.size(20.dp))
        Spacer(Modifier.width(8.dp))
        Text("Sound attached", color = Color(0xFFE65100), fontSize = 14.sp, fontWeight = FontWeight.Medium, modifier = Modifier.weight(1f))
        Icon(Icons.Default.Close, "Remove sound", tint = Color(0xFF9E9E9E), modifier = Modifier.size(18.dp).clickable { onRemove() })
    }
}

@Composable
private fun VideoPreviewWithTitle(
    videoUri: Uri,
    reelTitle: String,
    onTitleChange: (String) -> Unit,
    onRemoveVideo: () -> Unit
) {
    val context = LocalContext.current
    Row(
        modifier = Modifier.fillMaxWidth().height(200.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.Top
    ) {
        Column(Modifier.weight(1f)) {
            OutlinedTextField(
                value = reelTitle,
                onValueChange = onTitleChange,
                placeholder = { Text("Add description...", color = Color.LightGray) },
                colors = TextFieldDefaults.outlinedTextFieldColors(
                    backgroundColor = Color.Transparent,
                    focusedBorderColor = Color.Transparent,
                    unfocusedBorderColor = Color.Transparent
                ),
                modifier = Modifier.fillMaxWidth().height(150.dp)
            )
            Spacer(Modifier.height(8.dp))
            Button(
                onClick = { onTitleChange(reelTitle + "#") },
                colors = ButtonDefaults.buttonColors(backgroundColor = Color(0xFFF0F0F0)),
                shape = RoundedCornerShape(8.dp),
                elevation = null,
                modifier = Modifier.defaultMinSize(minHeight = 36.dp)
            ) { Text("# Hashtags", color = Color.Black) }
        }
        Spacer(Modifier.width(12.dp))
        Box(
            modifier = Modifier
                .size(width = 140.dp, height = 200.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(Color(0xFFE0E0E0))
        ) {
            val bitmap = remember(videoUri) {
                val retriever = MediaMetadataRetriever()
                retriever.setDataSource(context, videoUri)
                val frame = retriever.getFrameAtTime(1_000_000)
                retriever.release()
                frame
            }
            bitmap?.let {
                Image(it.asImageBitmap(), null, contentScale = ContentScale.Crop, modifier = Modifier.fillMaxSize())
            }
            Text("Preview", color = Color.White, modifier = Modifier.align(Alignment.TopStart).padding(8.dp))
            IconButton(onClick = onRemoveVideo, modifier = Modifier.align(Alignment.TopEnd).padding(end = 4.dp)) {
                androidx.compose.material.Icon(Icons.Default.Close, "Remove", tint = Color.Red)
            }
        }
    }
}

@Composable
private fun ProductDetailFields(
    formState: com.project.e_commerce.android.presentation.viewModel.addContent.ContentFormState,
    categoryBehavior: CategoryBehavior,
    viewModel: AddNewContentViewModel
) {
    CustomOutlinedTextField(
        value = formState.productName,
        onValueChange = viewModel::updateProductName,
        label = "Product Name",
        placeholder = "Enter product name"
    )
    Spacer(Modifier.height(8.dp))

    Text("Category", fontSize = 14.sp, fontWeight = FontWeight.Medium, color = Color(0xFF0066CC))
    Spacer(Modifier.height(4.dp))
    CategoryDropdown(
        selectedCategory = formState.selectedCategory,
        onCategorySelected = viewModel::updateCategory
    )
    Spacer(Modifier.height(8.dp))

    // Size + Color fields based on category behavior
    if (categoryBehavior.enableSize && categoryBehavior.enableColor) {
        SizeColorSection(categoryBehavior, viewModel)
    } else if (categoryBehavior.enableSize) {
        SizeOnlySection(viewModel)
    }

    Spacer(Modifier.height(8.dp))

    // Display size/color summary
    SizeColorSummary(
        sizes = formState.sizes,
        colorQuantities = formState.colorQuantities,
        enableColor = categoryBehavior.enableColor,
        onRemove = { size, color -> viewModel.removeSizeColorEntry(size, color) }
    )

    Spacer(Modifier.height(8.dp))

    if (!categoryBehavior.enableSize && !categoryBehavior.enableColor) {
        CustomOutlinedTextField(
            value = formState.productQuantity,
            onValueChange = viewModel::updateProductQuantity,
            label = "Quantity",
            placeholder = "Enter quantity"
        )
        Spacer(Modifier.height(8.dp))
    }

    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        CustomOutlinedTextField(
            value = formState.productPrice,
            onValueChange = viewModel::updateProductPrice,
            label = "Price",
            placeholder = "Enter price",
            modifier = Modifier.weight(1f)
        )
    }

    Spacer(Modifier.height(30.dp))
}

@Composable
private fun SizeColorSection(categoryBehavior: CategoryBehavior, viewModel: AddNewContentViewModel) {
    var selectedSizeStr by remember { mutableStateOf("") }
    DropdownWithStyle(
        label = "Select Size",
        options = categoryBehavior.units,
        selectedOption = selectedSizeStr,
        onOptionSelected = { selectedSizeStr = it }
    )
    Spacer(Modifier.height(8.dp))

    if (selectedSizeStr.isNotBlank()) {
        var selectedColor by remember { mutableStateOf("") }
        var quantityInput by remember { mutableStateOf("") }
        Row(verticalAlignment = Alignment.CenterVertically) {
            DropdownWithStyle(
                label = "Select Color",
                options = AddNewContentViewModel.COLOR_OPTIONS,
                selectedOption = selectedColor,
                onOptionSelected = { selectedColor = it },
                modifier = Modifier.weight(1f)
            )
            Spacer(Modifier.width(8.dp))
            QuantityField(value = quantityInput, onValueChange = { quantityInput = it }, modifier = Modifier.weight(0.6f))
            Spacer(Modifier.width(8.dp))
            AddButton {
                if (selectedColor.isNotBlank() && quantityInput.isNotBlank()) {
                    viewModel.addSizeColorEntry(selectedSizeStr, selectedColor, quantityInput)
                    selectedColor = ""
                    quantityInput = ""
                }
            }
        }
    }
}

@Composable
private fun SizeOnlySection(viewModel: AddNewContentViewModel) {
    Spacer(Modifier.height(8.dp))
    var customSize by remember { mutableStateOf("") }
    var quantityInput by remember { mutableStateOf("") }
    Row(verticalAlignment = Alignment.CenterVertically) {
        OutlinedTextField(
            value = customSize,
            onValueChange = { if (it.all(Char::isDigit)) customSize = it },
            placeholder = { Text("Size (ml)") },
            modifier = Modifier.weight(1f),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number, imeAction = ImeAction.Next),
            colors = standardFieldColors()
        )
        Spacer(Modifier.width(8.dp))
        QuantityField(value = quantityInput, onValueChange = { quantityInput = it }, modifier = Modifier.weight(1f))
        Spacer(Modifier.width(8.dp))
        AddButton {
            if (customSize.isNotBlank() && quantityInput.isNotBlank()) {
                viewModel.addSizeColorEntry(customSize, "", quantityInput)
                customSize = ""
                quantityInput = ""
            }
        }
    }
}

@Composable
private fun SizeColorSummary(
    sizes: List<String>,
    colorQuantities: Map<String, Map<String, String>>,
    enableColor: Boolean,
    onRemove: (String, String?) -> Unit
) {
    sizes.forEach { size ->
        if (!enableColor) {
            val qty = colorQuantities[size]?.get("") ?: ""
            SummaryRow(
                label = "Size: $size  Qty: $qty",
                onRemove = { onRemove(size, null) }
            )
        } else {
            colorQuantities[size]?.forEach { (color, qty) ->
                SummaryRow(
                    label = "Size: $size  Color: $color  Qty: $qty",
                    onRemove = { onRemove(size, color) }
                )
            }
        }
    }
}

@Composable
private fun SummaryRow(label: String, onRemove: () -> Unit) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 3.dp)
            .border(1.dp, Color(0xFFB3C1D1), RoundedCornerShape(8.dp))
            .padding(horizontal = 8.dp, vertical = 4.dp)
    ) {
        Text(label, fontWeight = FontWeight.Medium, color = Color(0xFF174378), modifier = Modifier.weight(1f))
        IconButton(onClick = onRemove) {
            Icon(Icons.Default.Close, "Remove", tint = Color.Red)
        }
    }
}

@Composable
private fun MarketplaceProductSection(
    product: com.project.e_commerce.domain.model.marketplace.MarketplaceProduct?,
    onSelectProduct: () -> Unit
) {
    Text("Marketplace Product to promote *", fontWeight = FontWeight.SemiBold, color = Color(0xFFFF9800), fontSize = 16.sp)
    Spacer(Modifier.height(8.dp))

    Surface(modifier = Modifier.fillMaxWidth(), color = Color(0xFFFFF3E0), shape = RoundedCornerShape(8.dp)) {
        Row(Modifier.padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.Info, null, tint = Color(0xFFFF9800), modifier = Modifier.size(20.dp))
            Spacer(Modifier.width(8.dp))
            Text(
                "You must select a product to promote from our CJ marketplace. You will earn a commission on every sale generated by this Reel!",
                fontSize = 12.sp, color = Color(0xFFE65100), lineHeight = 16.sp
            )
        }
    }

    Spacer(Modifier.height(12.dp))

    if (product != null) {
        SelectedProductCard(product = product, onChangeProduct = onSelectProduct)
    } else {
        OutlinedButton(
            onClick = onSelectProduct,
            modifier = Modifier.fillMaxWidth().height(56.dp),
            shape = RoundedCornerShape(8.dp),
            colors = ButtonDefaults.outlinedButtonColors(contentColor = Color(0xFFFF9800)),
            border = BorderStroke(2.dp, Color(0xFFFF9800))
        ) {
            Icon(painterResource(R.drawable.ic_products_filled), null, tint = Color(0xFFFF9800))
            Spacer(Modifier.width(8.dp))
            Text("Select a Marketplace Product", fontSize = 16.sp, fontWeight = FontWeight.Medium)
        }
    }
}

@Composable
private fun SelectedProductCard(
    product: com.project.e_commerce.domain.model.marketplace.MarketplaceProduct,
    onChangeProduct: () -> Unit
) {
    Surface(
        modifier = Modifier.fillMaxWidth().border(2.dp, Color(0xFFFF9800), RoundedCornerShape(12.dp)),
        shape = RoundedCornerShape(12.dp),
        color = Color(0xFFFF9800).copy(alpha = 0.05f)
    ) {
        Row(Modifier.fillMaxWidth().padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            AsyncImage(
                model = product.mainImageUrl,
                contentDescription = null,
                modifier = Modifier.size(60.dp).clip(RoundedCornerShape(8.dp)).background(Color(0xFFF5F5F5))
            )
            Spacer(Modifier.width(12.dp))
            Column(Modifier.weight(1f)) {
                Text(product.name, fontSize = 14.sp, fontWeight = FontWeight.Medium, color = Color.Black, maxLines = 2)
                Spacer(Modifier.height(4.dp))
                Text(product.getFormattedPrice(), fontSize = 14.sp, fontWeight = FontWeight.Bold, color = Color(0xFFFF9800))
                Text(
                    "Earn: ${String.format("%.1f", product.commissionRate)}% (${product.getFormattedCommission()})",
                    fontSize = 11.sp, color = Color(0xFF4CAF50), fontWeight = FontWeight.Medium
                )
            }
            Column(horizontalAlignment = Alignment.End) {
                IconButton(onClick = onChangeProduct) {
                    Icon(Icons.Default.Edit, "Change", tint = Color(0xFFFF9800))
                }
                Text("Change", fontSize = 10.sp, color = Color(0xFFFF9800))
            }
        }
    }
}

// ──────────────────────────────────────────────────────
// Reusable form components
// ──────────────────────────────────────────────────────

@Composable
private fun QuantityField(value: String, onValueChange: (String) -> Unit, modifier: Modifier = Modifier) {
    OutlinedTextField(
        value = value,
        onValueChange = { if (it.all(Char::isDigit)) onValueChange(it) },
        placeholder = { Text("Qty") },
        modifier = modifier,
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number, imeAction = ImeAction.Done),
        colors = standardFieldColors()
    )
}

@Composable
private fun AddButton(onClick: () -> Unit) {
    Button(
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(backgroundColor = Color(0xFFFF6F00))
    ) { Text("Add", color = Color.White) }
}

@Composable
private fun standardFieldColors() = TextFieldDefaults.outlinedTextFieldColors(
    focusedBorderColor = Color(0xFF1B7ACE),
    unfocusedBorderColor = Color(0xFFB3C1D1),
    disabledBorderColor = Color(0xFFB3C1D1),
    backgroundColor = Color.White,
    disabledTextColor = Color.Black,
    disabledPlaceholderColor = Color(0xFFB3C1D1)
)

// ──────────────────────────────────────────────────────
// Public reusable composables (used by other screens)
// ──────────────────────────────────────────────────────

@Composable
fun DropdownWithStyle(
    label: String,
    options: List<String>,
    selectedOption: String,
    onOptionSelected: (String) -> Unit,
    modifier: Modifier = Modifier.fillMaxWidth()
) {
    var expanded by remember { mutableStateOf(false) }
    Box(modifier = modifier.clickable { expanded = true }) {
        OutlinedTextField(
            value = selectedOption,
            onValueChange = {},
            readOnly = true,
            enabled = false,
            placeholder = { Text(label, color = Color(0xFFB3C1D1)) },
            trailingIcon = {
                Icon(Icons.Default.ArrowDropDown, null, modifier = Modifier.rotate(if (expanded) 180f else 0f))
            },
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(8.dp),
            colors = standardFieldColors()
        )
        DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }, modifier = Modifier.fillMaxWidth()) {
            options.forEach {
                DropdownMenuItem(onClick = { onOptionSelected(it); expanded = false }) { Text(it) }
            }
        }
    }
}

@Composable
fun CategoryDropdown(
    selectedCategory: String?,
    onCategorySelected: (String) -> Unit
) {
    var expanded by remember { mutableStateOf(false) }
    Box {
        Box(Modifier.fillMaxWidth().clickable { expanded = true }) {
            OutlinedTextField(
                value = selectedCategory ?: "",
                onValueChange = {},
                readOnly = true,
                enabled = false,
                placeholder = { Text("Select Category", color = Color(0xFFB3C1D1)) },
                trailingIcon = {
                    Icon(Icons.Default.ArrowDropDown, null, modifier = Modifier.rotate(if (expanded) 180f else 0f))
                },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp),
                colors = standardFieldColors(),
                singleLine = true
            )
        }
        DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }, modifier = Modifier.fillMaxWidth()) {
            AddNewContentViewModel.CATEGORIES.forEach { category ->
                DropdownMenuItem(onClick = { onCategorySelected(category); expanded = false }) { Text(category) }
            }
        }
    }
}

@Composable
fun CustomOutlinedTextField(
    value: String,
    onValueChange: (String) -> Unit,
    label: String,
    placeholder: String,
    modifier: Modifier = Modifier,
    minLines: Int = 1,
    trailingIcon: @Composable (() -> Unit)? = null
) {
    Column(modifier = modifier) {
        Text(label, fontSize = 14.sp, fontWeight = FontWeight.Medium, color = Color(0xFF0066CC))
        Spacer(Modifier.height(4.dp))
        OutlinedTextField(
            value = value,
            onValueChange = onValueChange,
            placeholder = { Text(placeholder, color = Color(0xFF114B7F)) },
            modifier = Modifier.fillMaxWidth().heightIn(min = (minLines * 24).dp),
            shape = RoundedCornerShape(8.dp),
            trailingIcon = trailingIcon,
            colors = TextFieldDefaults.outlinedTextFieldColors(
                focusedBorderColor = Color(0xFF1B7ACE),
                unfocusedBorderColor = Color(0xFFB3C1D1),
                cursorColor = Color(0xFF174378),
                backgroundColor = Color.White
            )
        )
    }
}

@Composable
fun UploadBox(height: Dp, text: String, buttonText: String, note: String, onClick: () -> Unit) {
    Box(
        modifier = Modifier.fillMaxWidth().height(height).border(1.dp, Color(0xFFB6B6B6), RoundedCornerShape(8.dp)),
        contentAlignment = Alignment.Center
    ) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Icon(painterResource(R.drawable.upload_icon), null, tint = Color(0xFF0066CC), modifier = Modifier.size(32.dp))
            Spacer(Modifier.height(4.dp))
            Text(text, color = Color.Gray, fontSize = 14.sp)
            Spacer(Modifier.height(8.dp))
            Button(
                onClick = onClick,
                colors = ButtonDefaults.buttonColors(backgroundColor = Color(0xFF1B7ACE)),
                shape = RoundedCornerShape(12.dp)
            ) { Text(buttonText, color = Color.White) }
            Spacer(Modifier.height(8.dp))
            Text(note, color = Color.Gray, fontSize = 11.sp)
        }
    }
}

@Composable
fun SelectedImage(uri: Uri, onRemove: () -> Unit) {
    Box(Modifier.size(100.dp).padding(4.dp)) {
        AsyncImage(
            model = uri,
            contentDescription = null,
            modifier = Modifier.fillMaxSize().clip(RoundedCornerShape(8.dp))
        )
        androidx.compose.material.IconButton(
            onClick = onRemove,
            modifier = Modifier.align(Alignment.TopEnd).size(24.dp)
        ) {
            androidx.compose.material.Icon(Icons.Default.Close, "Remove", tint = Color.Red)
        }
    }
}
