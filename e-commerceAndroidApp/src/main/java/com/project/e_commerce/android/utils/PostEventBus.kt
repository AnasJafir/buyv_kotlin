package com.project.e_commerce.android.utils

import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow

/**
 * Global Event Bus to synchronize post/reel deletions across different ViewModels
 */
object PostEventBus {
    private val _events = MutableSharedFlow<PostEvent>()
    val events = _events.asSharedFlow()

    suspend fun emit(event: PostEvent) {
        _events.emit(event)
    }
}

sealed class PostEvent {
    data class PostDeleted(val postId: String) : PostEvent()
}
