package com.project.e_commerce.android.presentation.viewModel.addContent

import android.content.Context
import android.net.Uri
import android.util.Log
import android.widget.Toast
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.cloudinary.android.MediaManager
import com.cloudinary.android.callback.ErrorInfo
import com.cloudinary.android.callback.UploadCallback
import com.cloudinary.utils.ObjectUtils
import com.project.e_commerce.android.data.remote.CloudinaryConfig
import com.project.e_commerce.data.local.CurrentUserProvider
import com.project.e_commerce.data.remote.api.MarketplaceApiService
import com.project.e_commerce.domain.model.Result
import com.project.e_commerce.domain.model.marketplace.CreatePromotionRequest
import com.project.e_commerce.domain.model.marketplace.MarketplaceProduct
import com.project.e_commerce.domain.usecase.post.CreatePostUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

/**
 * Form state for AddNewContentScreen.
 * Consolidates 13+ individual mutableStateOf into one data class.
 */
data class ContentFormState(
    val reelTitle: String = "",
    val productName: String = "",
    val description: String = "",
    val productPrice: String = "",
    val productQuantity: String = "",
    val productTags: String = "",
    val selectedCategory: String = "",
    val reelVideoUri: Uri? = null,
    val productImageUris: List<Uri> = emptyList(),
    val selectedMarketplaceProduct: MarketplaceProduct? = null,
    val showProductSelectionSheet: Boolean = false,
    val activeSoundUid: String? = null,
    val sizes: List<String> = emptyList(),
    val colorQuantities: Map<String, Map<String, String>> = emptyMap()
)

/**
 * Upload progress state — separate from form since it's transient.
 */
data class UploadState(
    val isUploading: Boolean = false,
    val step: String = ""
)

/**
 * Category configuration: what fields to show per category.
 */
data class CategoryBehavior(
    val units: List<String>,
    val enableSize: Boolean,
    val enableColor: Boolean
)

/**
 * ViewModel for the AddNewContent screen.
 *
 * Responsibilities:
 * - Manages form state (single StateFlow)
 * - Orchestrates Cloudinary upload (video + images)
 * - Saves post to backend via CreatePostUseCase
 * - Links marketplace product via MarketplaceApiService
 */
class AddNewContentViewModel(
    private val currentUserProvider: CurrentUserProvider,
    private val createPostUseCase: CreatePostUseCase,
    private val marketplaceApi: MarketplaceApiService,
    private val soundRepository: com.project.e_commerce.domain.repository.SoundRepository
) : ViewModel() {

    private val _formState = MutableStateFlow(ContentFormState())
    val formState: StateFlow<ContentFormState> = _formState.asStateFlow()

    private val _uploadState = MutableStateFlow(UploadState())
    val uploadState: StateFlow<UploadState> = _uploadState.asStateFlow()

    companion object {
        private const val TAG = "AddContentVM"

        val CATEGORY_BEHAVIORS = mapOf(
            "Perfumes" to CategoryBehavior(units = emptyList(), enableSize = true, enableColor = false),
            "Clothing" to CategoryBehavior(units = listOf("XS", "S", "M", "L", "XL"), enableSize = true, enableColor = true),
            "Furniture" to CategoryBehavior(units = emptyList(), enableSize = true, enableColor = false),
            "Electronics" to CategoryBehavior(units = emptyList(), enableSize = false, enableColor = false),
            "Accessories" to CategoryBehavior(units = listOf("one size"), enableSize = true, enableColor = true)
        )

        val COLOR_OPTIONS = listOf("Red", "Blue", "Black", "White", "Yellow")
        val CATEGORIES = listOf("Perfumes", "Clothing", "Furniture", "Electronics", "Accessories")
    }

    // ──────────────────────────────────────────────
    // Form field updates
    // ──────────────────────────────────────────────

    fun updateReelTitle(value: String) = _formState.update { it.copy(reelTitle = value) }
    fun updateProductName(value: String) = _formState.update { it.copy(productName = value) }
    fun updateDescription(value: String) = _formState.update { it.copy(description = value) }
    fun updateProductPrice(value: String) = _formState.update { it.copy(productPrice = value) }
    fun updateProductQuantity(value: String) = _formState.update { it.copy(productQuantity = value) }
    fun updateProductTags(value: String) = _formState.update { it.copy(productTags = value) }

    fun updateCategory(category: String) {
        _formState.update {
            it.copy(
                selectedCategory = category,
                sizes = emptyList(),
                colorQuantities = emptyMap()
            )
        }
    }

    fun setReelVideoUri(uri: Uri?) = _formState.update { it.copy(reelVideoUri = uri) }

    fun addImageUris(uris: List<Uri>) {
        _formState.update { state ->
            val existing = state.productImageUris.toSet()
            val newUris = uris.filterNot { it in existing }
            state.copy(productImageUris = state.productImageUris + newUris)
        }
    }

    fun removeImageAt(index: Int) {
        _formState.update { state ->
            state.copy(productImageUris = state.productImageUris.toMutableList().also {
                if (index in it.indices) it.removeAt(index)
            })
        }
    }

    fun setMarketplaceProduct(product: MarketplaceProduct?) {
        _formState.update { state ->
            val rawDescription = product?.description ?: product?.shortDescription ?: ""
            val cleanDescription = com.project.e_commerce.data.util.HtmlSanitizer.toPlainText(rawDescription)
            val cleanName = com.project.e_commerce.data.util.HtmlSanitizer.toPlainText(product?.name ?: "")
            state.copy(
                selectedMarketplaceProduct = product,
                productName = cleanName.ifBlank { state.productName },
                description = if (state.description.isBlank()) cleanDescription else state.description,
                productPrice = product?.sellingPrice?.toString() ?: state.productPrice,
                selectedCategory = if (state.selectedCategory.isBlank()) product?.categoryName ?: "Electronics" else state.selectedCategory
            )
        }
    }

    fun setShowProductSheet(show: Boolean) = _formState.update { it.copy(showProductSelectionSheet = show) }
    fun setSoundUid(uid: String?) = _formState.update { it.copy(activeSoundUid = uid) }

    fun addSizeColorEntry(size: String, color: String, quantity: String) {
        _formState.update { state ->
            val newSizes = if (size !in state.sizes) state.sizes + size else state.sizes
            val newCQ = state.colorQuantities.toMutableMap()
            val sizeMap = (newCQ[size] ?: emptyMap()).toMutableMap()
            sizeMap[color] = quantity
            newCQ[size] = sizeMap
            state.copy(sizes = newSizes, colorQuantities = newCQ)
        }
    }

    fun removeSizeColorEntry(size: String, color: String? = null) {
        _formState.update { state ->
            val newCQ = state.colorQuantities.toMutableMap()
            if (color != null) {
                val sizeMap = (newCQ[size] ?: emptyMap()).toMutableMap()
                sizeMap.remove(color)
                if (sizeMap.isEmpty()) {
                    newCQ.remove(size)
                    state.copy(
                        sizes = state.sizes - size,
                        colorQuantities = newCQ
                    )
                } else {
                    newCQ[size] = sizeMap
                    state.copy(colorQuantities = newCQ)
                }
            } else {
                newCQ.remove(size)
                state.copy(
                    sizes = state.sizes - size,
                    colorQuantities = newCQ
                )
            }
        }
    }

    // ──────────────────────────────────────────────
    // Pre-load product (from navigation argument)
    // ──────────────────────────────────────────────

    fun loadPreSelectedProduct(productId: String) {
        viewModelScope.launch {
            try {
                val product = marketplaceApi.getProduct(productId)
                setMarketplaceProduct(product)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to load pre-selected product: ${e.message}")
            }
        }
    }

    // ──────────────────────────────────────────────
    // Upload orchestration
    // ──────────────────────────────────────────────

    fun submit(context: Context, onPostCreated: (() -> Unit)?) {
        val form = _formState.value

        // Validation
        if (form.selectedMarketplaceProduct == null) {
            Toast.makeText(context, "You must select a Marketplace product before publishing", Toast.LENGTH_LONG).show()
            return
        }
        if (form.reelVideoUri == null && form.productImageUris.isEmpty()) {
            Toast.makeText(context, "Please select a video or at least one image", Toast.LENGTH_SHORT).show()
            return
        }
        @Suppress("SENSELESS_COMPARISON")
        if (form.selectedMarketplaceProduct == null &&
            (form.productName.isBlank() || form.selectedCategory.isBlank() || form.productPrice.isBlank())
        ) {
            Toast.makeText(context, "Please fill required fields", Toast.LENGTH_SHORT).show()
            return
        }

        _uploadState.value = UploadState(isUploading = true, step = "Starting upload...")

        if (form.reelVideoUri != null) {
            uploadVideo(context, form, onPostCreated)
        } else {
            updateStep("Uploading images...")
            uploadImagesAndSave("", context, form, onPostCreated)
        }
    }

    private fun uploadVideo(context: Context, form: ContentFormState, onPostCreated: (() -> Unit)?) {
        updateStep("Uploading video...")
        MediaManager.get().upload(form.reelVideoUri!!)
            .unsigned(CloudinaryConfig.UPLOAD_PRESET)
            .option("public_id", "reels/${System.currentTimeMillis()}")
            .option("folder", CloudinaryConfig.Folders.REELS)
            .option("resource_type", "video")
            .callback(object : UploadCallback {
                override fun onStart(requestId: String) {
                    postToMain { updateStep("Uploading video...") }
                }

                override fun onSuccess(requestId: String, resultData: Map<Any?, Any?>) {
                    val videoUrl = resultData["secure_url"] as String
                      
                      viewModelScope.launch {
                          // SOUND-003: Extract audio locally on backend if no sound was selected
                          if (form.activeSoundUid == null) {
                              try {
                                  postToMain { updateStep("Extracting audio...") }
                                  val newSound = soundRepository.extractAudioFromVideo(
                                      videoUrl = videoUrl,
                                      title = "Original sound - ${form.productName.takeIf { it.isNotBlank() } ?: "Reel"}"
                                  )
                                  setSoundUid(newSound.uid)
                              } catch (e: Exception) {
                                  Log.e(TAG, "Audio extraction failed, creating post without sound: ${e.message}")
                              }
                          }
                          
                          postToMain {
                              // We pass the updated form so the new soundUid is picked up!
                              val updatedForm = _formState.value
                              updateStep(if (updatedForm.productImageUris.isNotEmpty()) "Uploading images..." else "Saving reel...")
                              uploadImagesAndSave(videoUrl, context, updatedForm, onPostCreated)
                          }
                      }
                }

                override fun onError(requestId: String, error: ErrorInfo) {
                    Log.e(TAG, "Video upload failed: ${error.description}")
                    postToMain {
                        _uploadState.value = UploadState()
                        Toast.makeText(context, "Video upload failed: ${error.description}", Toast.LENGTH_LONG).show()
                    }
                }

                override fun onReschedule(requestId: String, error: ErrorInfo) {}

                override fun onProgress(requestId: String, bytes: Long, totalBytes: Long) {
                    val percent = if (totalBytes > 0) (bytes * 100 / totalBytes).toInt() else 0
                    postToMain { updateStep("Uploading video ($percent%)...") }
                }
            }).dispatch()
    }

    private fun uploadImagesAndSave(
        videoUrl: String,
        context: Context,
        form: ContentFormState,
        onPostCreated: (() -> Unit)?
    ) {
        if (form.productImageUris.isEmpty()) {
            updateStep("Saving reel...")
            saveToBackend(videoUrl, emptyList(), context, form, onPostCreated)
            return
        }

        var uploadedCount = 0
        val imageUrls = mutableListOf<String>()
        val total = form.productImageUris.size
        updateStep("Uploading images (0/$total)...")

        form.productImageUris.forEach { uri ->
            MediaManager.get().upload(uri)
                .unsigned(CloudinaryConfig.UPLOAD_PRESET)
                .option("public_id", "products/${System.currentTimeMillis()}_${uri.lastPathSegment}")
                .option("folder", CloudinaryConfig.Folders.PRODUCTS)
                .callback(object : UploadCallback {
                    override fun onStart(requestId: String) {}

                    override fun onSuccess(requestId: String, resultData: Map<Any?, Any?>) {
                        val imageUrl = resultData["secure_url"] as String
                        synchronized(imageUrls) {
                            imageUrls.add(imageUrl)
                            uploadedCount++
                        }
                        postToMain { updateStep("Uploading images ($uploadedCount/$total)...") }
                        if (uploadedCount == total) {
                            postToMain {
                                updateStep("Saving reel...")
                                saveToBackend(videoUrl, imageUrls.toList(), context, form, onPostCreated)
                            }
                        }
                    }

                    override fun onError(requestId: String, error: ErrorInfo) {
                        postToMain {
                            _uploadState.value = UploadState()
                            Toast.makeText(context, "Image upload failed: ${error.description}", Toast.LENGTH_SHORT).show()
                        }
                    }

                    override fun onReschedule(requestId: String, error: ErrorInfo) {}
                    override fun onProgress(requestId: String, bytes: Long, totalBytes: Long) {}
                }).dispatch()
        }
    }

    private fun saveToBackend(
        videoUrl: String,
        imageUrls: List<String>,
        context: Context,
        form: ContentFormState,
        onPostCreated: (() -> Unit)?
    ) {
        viewModelScope.launch {
            try {
                val caption = buildCaption(form)
                val effectiveMediaUrl = videoUrl.ifBlank { imageUrls.firstOrNull() ?: "" }
                val postType = if (videoUrl.isNotBlank()) "reel" else "photo"

                val additionalData = mutableMapOf<String, String>()
                if (imageUrls.isNotEmpty()) {
                    additionalData["thumbnail_url"] = imageUrls.joinToString(",")
                }
                if (!form.activeSoundUid.isNullOrBlank()) {
                    additionalData["sound_uid"] = form.activeSoundUid
                }

                val result = createPostUseCase(
                    type = postType,
                    mediaUrl = effectiveMediaUrl,
                    caption = caption.ifBlank { null },
                    additionalData = additionalData.ifEmpty { null }
                )

                when (result) {
                    is Result.Success -> {
                        val createdPost = result.data
                        linkMarketplaceProduct(createdPost.id, form.selectedMarketplaceProduct, context)
                        _uploadState.value = UploadState()
                        onPostCreated?.invoke()
                    }
                    is Result.Error -> {
                        Log.e(TAG, "Failed to create post: ${result.error}")
                        Toast.makeText(context, "Failed to create content: ${result.error}", Toast.LENGTH_SHORT).show()
                        _uploadState.value = UploadState()
                    }
                    is Result.Loading -> { /* should not happen */ }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Exception creating post: ${e.message}")
                Toast.makeText(context, "Failed to save: ${e.message}", Toast.LENGTH_SHORT).show()
                _uploadState.value = UploadState()
            }
        }
    }

    private suspend fun linkMarketplaceProduct(
        postId: String,
        product: MarketplaceProduct?,
        context: Context
    ) {
        if (product == null) {
            Toast.makeText(context, "Reel added successfully", Toast.LENGTH_SHORT).show()
            return
        }
        try {
            marketplaceApi.createPromotion(
                CreatePromotionRequest(postId = postId, productId = product.id)
            )
            Toast.makeText(context, "Reel added and linked to product successfully", Toast.LENGTH_SHORT).show()
        } catch (e: Exception) {
            Log.e(TAG, "Post created but failed to link product: ${e.message}")
            Toast.makeText(context, "Reel added but failed to link product", Toast.LENGTH_SHORT).show()
        }
    }

    // ──────────────────────────────────────────────
    // Helpers
    // ──────────────────────────────────────────────

    private fun buildCaption(form: ContentFormState): String = buildString {
        if (form.reelTitle.isNotBlank()) append(form.reelTitle)
        if (form.description.isNotBlank()) {
            if (isNotEmpty()) append(" - ")
            append(form.description)
        }
        if (form.productTags.isNotBlank()) {
            if (isNotEmpty()) append(" ")
            append(form.productTags.split(",").joinToString(" ") { "#${it.trim()}" })
        }
        if (!form.activeSoundUid.isNullOrBlank()) {
            append("\n{{sound:${form.activeSoundUid}}}")
        }
    }

    private fun updateStep(step: String) {
        _uploadState.update { it.copy(step = step) }
    }

    private fun postToMain(block: () -> Unit) {
        android.os.Handler(android.os.Looper.getMainLooper()).post(block)
    }
}

