package com.project.e_commerce.android.presentation.ui.composable.composableScreen.public

import android.net.Uri
import androidx.annotation.OptIn
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.compose.ui.input.pointer.pointerInput
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.compose.LocalLifecycleOwner
import androidx.media3.common.MediaItem
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView
import androidx.media3.ui.PlayerView.SHOW_BUFFERING_ALWAYS
import android.util.Log
import android.widget.TextView
import android.view.Gravity
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import android.media.AudioManager
import android.media.AudioFocusRequest
import android.os.Build
import androidx.media3.common.AudioAttributes
import androidx.media3.common.C
import androidx.media3.datasource.DataSource
import androidx.media3.exoplayer.DefaultLoadControl
import androidx.media3.exoplayer.LoadControl
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory
import com.project.e_commerce.android.presentation.utils.VideoPlayerCache

@OptIn(UnstableApi::class)
@Composable
fun VideoPlayer(
    modifier: Modifier = Modifier,
    uri: Uri?,
    isPlaying: Boolean,
    onPlaybackStarted: () -> Unit,
    onPlaybackToggle: ((Boolean) -> Unit)? = null,
    onDoubleTap: ((Offset) -> Unit)? = null // NEW: Pass tap position
) {

    val context = LocalContext.current
    val lifecycleOwner = LocalLifecycleOwner.current
    Log.d("VideoPlayer", "🎥 VideoPlayer composable called with URI: $uri, isPlaying: $isPlaying")
    
    var hasError by remember { mutableStateOf(false) }
    var errorMessage by remember { mutableStateOf("") }
    var isLoading by remember { mutableStateOf(true) }
    var showPlayButton by remember { mutableStateOf(false) }
    var isPlayerPlaying by remember { mutableStateOf(isPlaying) }

    // NEW: Track if video was playing before going to background
    var wasPlayingBeforeBackground by remember { mutableStateOf(false) }
    var isAppInBackground by remember { mutableStateOf(false) }

    Log.d("VideoPlayer", "🎥 VideoPlayer state initialized - hasError: $hasError, errorMessage: $errorMessage")

    // Validate URI upfront
    if (uri == null || uri.toString().isBlank() || !uri.toString().startsWith("http")) {
        Log.w("VideoPlayer", "🎥 Invalid URI: $uri")
        hasError = true
        errorMessage = "Invalid video URL"
        isLoading = false
    }
    
    var exoPlayer by remember { mutableStateOf<ExoPlayer?>(null) }
    var shouldCallPlaybackStarted by remember { mutableStateOf(false) }

    // SIMPLIFIED: Just lifecycle management, no complex audio focus
    DisposableEffect(lifecycleOwner) {
        val observer = LifecycleEventObserver { _, event ->
            Log.d("VideoPlayer", "🎥 Lifecycle event: $event")
            when (event) {
                Lifecycle.Event.ON_PAUSE -> {
                    Log.d("VideoPlayer", "🎥 ON_PAUSE - App going to background")
                    isAppInBackground = true
                    exoPlayer?.let { player ->
                        if (player.isPlaying) {
                            wasPlayingBeforeBackground = true
                            Log.d("VideoPlayer", "🎥 Pausing player - was playing, saving state")
                            player.pause()
                            player.playWhenReady = false // Force stop
                        } else {
                            wasPlayingBeforeBackground = false
                            Log.d("VideoPlayer", "🎥 Player was already paused")
                        }
                    }
                }
                Lifecycle.Event.ON_RESUME -> {
                    Log.d("VideoPlayer", "🎥 ON_RESUME - App coming to foreground")
                    isAppInBackground = false
                    // Reset the flag when app comes back to foreground
                    Log.d("VideoPlayer", "🎥 App resumed - videos can now play normally")
                }
                Lifecycle.Event.ON_STOP -> {
                    Log.d("VideoPlayer", "🎥 ON_STOP - App stopped, force stopping playback")
                    isAppInBackground = true
                    exoPlayer?.let { player ->
                        if (player.isPlaying) {
                            Log.d("VideoPlayer", "🎥 Force stopping playback on app stop")
                            player.pause()
                            player.playWhenReady = false
                            player.stop()
                        }
                    }
                }
                else -> {
                    Log.d("VideoPlayer", "🎥 Other lifecycle event: $event")
                }
            }
        }

        lifecycleOwner.lifecycle.addObserver(observer)

        onDispose {
            Log.d("VideoPlayer", "🎥 Removing lifecycle observer")
            lifecycleOwner.lifecycle.removeObserver(observer)
        }
    }

    // Additional safeguard - pause when composition leaves
    DisposableEffect(Unit) {
        onDispose {
            Log.d("VideoPlayer", "🎥 VideoPlayer composition disposed - stopping playback")
            exoPlayer?.let { player ->
                if (player.isPlaying) {
                    Log.d("VideoPlayer", "🎥 Force pausing on composition dispose")
                    player.pause()
                    player.playWhenReady = false
                }
            }
        }
    }

    DisposableEffect(uri) {
        Log.d("VideoPlayer", "🎥 DisposableEffect started for URI: $uri")
        
        var localExoPlayer: ExoPlayer? = null

        if (!hasError) {
            // Create ExoPlayer safely
            runCatching {
                Log.d("VideoPlayer", "🎥 Creating ExoPlayer instance with cache support and optimized buffering")
                
                // Get cached DataSource factory
                val cacheDataSourceFactory: DataSource.Factory = VideoPlayerCache.getCacheDataSourceFactory(context)
                
                // Create MediaSource factory with cache
                val mediaSourceFactory = DefaultMediaSourceFactory(cacheDataSourceFactory)
                
                // Configure LoadControl for optimized buffering (especially for slow networks)
                val loadControl: LoadControl = DefaultLoadControl.Builder()
                    .setBufferDurationsMs(
                        /* minBufferMs = */ 2500,          // 2.5s minimum buffer (réduit de 15s par défaut)
                        /* maxBufferMs = */ 10000,         // 10s maximum buffer (réduit de 50s par défaut)
                        /* bufferForPlaybackMs = */ 1000,  // 1s requis pour démarrer (réduit de 2.5s)
                        /* bufferForPlaybackAfterRebufferMs = */ 2000  // 2s requis après rebuffering (réduit de 5s)
                    )
                    .setPrioritizeTimeOverSizeThresholds(true)  // Prioriser le temps sur la taille
                    .build()
                
                // Build ExoPlayer with cache, media source, and load control
                val player = ExoPlayer.Builder(context)
                    .setMediaSourceFactory(mediaSourceFactory)
                    .setLoadControl(loadControl)
                    .build()
                    
                localExoPlayer = player
                exoPlayer = player
                Log.d("VideoPlayer", "🎥 ExoPlayer created with optimized buffering (cache: ${VideoPlayerCache.getCacheSizeMB()})")

                // Set basic audio attributes (without strict focus handling)
                player.setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(C.AUDIO_CONTENT_TYPE_MOVIE)
                        .setUsage(C.USAGE_MEDIA)
                        .build(),
                    false // Don't handle focus automatically - we'll do it manually
                )

                // Add error listener first
                player.addListener(object : Player.Listener {
                    override fun onPlayerError(error: PlaybackException) {
                        Log.e("VideoPlayer", "🎥 PLAYER ERROR: ${error.message}", error)
                        hasError = true
                        errorMessage = "Playback failed"
                        isLoading = false
                        showPlayButton = false
                    }
                    
                    override fun onPlaybackStateChanged(playbackState: Int) {
                        Log.d("VideoPlayer", "🎥 Playback state changed: $playbackState")
                        when (playbackState) {
                            Player.STATE_BUFFERING -> {
                                isLoading = true
                                showPlayButton = false
                            }

                            Player.STATE_READY -> {
                                isLoading = false
                                showPlayButton = !isPlayerPlaying
                                if (isPlayerPlaying && !shouldCallPlaybackStarted) {
                                    shouldCallPlaybackStarted = true
                                }
                            }

                            Player.STATE_ENDED -> {
                                Log.d("VideoPlayer", "🎥 Playback ended, looping")
                                player.seekTo(0)
                                if (isPlayerPlaying && !isAppInBackground) {
                                    player.play()
                                }
                            }

                            Player.STATE_IDLE -> {
                                isLoading = false
                                showPlayButton = true
                            }
                        }
                    }

                    override fun onIsPlayingChanged(isPlaying: Boolean) {
                        Log.d(
                            "VideoPlayer",
                            "🎥 Player isPlaying changed: $isPlaying, appInBackground: $isAppInBackground"
                        )
                        isPlayerPlaying = isPlaying
                        showPlayButton = !isPlaying
                        if (isPlaying && !shouldCallPlaybackStarted) {
                            shouldCallPlaybackStarted = true
                        }

                        // SIMPLIFIED: Only force pause if app is in background AND video is playing
                        if (isPlaying && isAppInBackground) {
                            Log.w("VideoPlayer", "🎥 Video playing in background! Force pausing...")
                            player.pause()
                            player.playWhenReady = false
                        }
                    }
                })

                // Setup media item safely
                if (uri != null) {
                    try {
                        Log.d("VideoPlayer", "🎥 Setting media item for URI: $uri")
                        val mediaItem = MediaItem.fromUri(uri)
                        player.setMediaItem(mediaItem)
                        Log.d("VideoPlayer", "✅ Media item set successfully")

                        player.prepare()
                        Log.d("VideoPlayer", "✅ Player prepared successfully")

                        // SIMPLIFIED: Only check background state, not audio focus
                        if (isPlaying && !isAppInBackground) {
                            player.playWhenReady = true
                            player.play()
                            Log.d("VideoPlayer", "✅ Autoplay started")
                        } else {
                            player.playWhenReady = false
                            Log.d(
                                "VideoPlayer",
                                "✅ Player prepared but not auto-playing (background: $isAppInBackground)"
                            )
                        }

                    } catch (e: Exception) {
                        Log.e("VideoPlayer", "🎥 Error setting up media", e)
                        hasError = true
                        errorMessage = "Failed to load video"
                        isLoading = false
                    }
                } else {
                    Log.w("VideoPlayer", "🎥 URI is null, cannot create media item")
                    hasError = true
                    errorMessage = "No video URL provided"
                    isLoading = false
                }

            }.onFailure { e ->
                Log.e("VideoPlayer", "🎥 Error creating ExoPlayer", e)
                hasError = true
                errorMessage = "Video player initialization failed"
                isLoading = false
            }
        }
        
        onDispose {
            Log.d("VideoPlayer", "🎥 Disposing ExoPlayer")
            localExoPlayer?.let { player ->
                runCatching {
                    if (player.isPlaying) {
                        Log.d("VideoPlayer", "🎥 Pausing player before disposal")
                        player.pause()
                        player.playWhenReady = false
                    }
                    Log.d("VideoPlayer", "🎥 Stopping player before disposal")
                    player.stop()
                    Log.d("VideoPlayer", "🎥 Releasing player")
                    player.release()
                    Log.d("VideoPlayer", "🎥 Player released successfully")
                }.onFailure { e ->
                    Log.e("VideoPlayer", "🎥 Error during player disposal", e)
                }
            }
            exoPlayer = null
        }
    }
    
    // Handle the callback in a separate LaunchedEffect
    LaunchedEffect(shouldCallPlaybackStarted) {
        if (shouldCallPlaybackStarted) {
            Log.d("VideoPlayer", "🎥 Calling onPlaybackStarted callback")
            onPlaybackStarted()
            shouldCallPlaybackStarted = false
        }
    }
    
    // Handle play/pause state changes
    LaunchedEffect(isPlaying, hasError) {
        Log.d(
            "VideoPlayer",
            "🎥 LaunchedEffect triggered - isPlaying: $isPlaying, hasError: $hasError"
        )
        exoPlayer?.let { player ->
            if (isPlaying) {
                Log.d("VideoPlayer", "🎥 Starting playback from LaunchedEffect")
                player.play()
                isPlayerPlaying = true
            } else {
                Log.d("VideoPlayer", "🎥 Pausing playback from LaunchedEffect")
                player.pause()
                isPlayerPlaying = false
            }
        }
    }

    // NEW: Handle tap to toggle play/pause
    val handleTap = {
        Log.d(
            "VideoPlayer",
            "🎥 Video tapped - current state: isPlaying=$isPlayerPlaying, inBackground=$isAppInBackground"
        )
        if (isAppInBackground) {
            Log.d("VideoPlayer", "🎥 Ignoring tap - app is in background")
        } else {
            exoPlayer?.let { player ->
                if (isPlayerPlaying) {
                    Log.d("VideoPlayer", "🎥 Pausing video on tap")
                    player.pause()
                    player.playWhenReady = false
                    onPlaybackToggle?.invoke(false)
                } else {
                    Log.d("VideoPlayer", "🎥 Playing video on tap")
                    player.play()
                    onPlaybackToggle?.invoke(true)
                }
            }
        }
    }

    Box(
        modifier = modifier
            .fillMaxSize()
            .pointerInput(isPlayerPlaying, isAppInBackground) {
                detectTapGestures(
                    onTap = { handleTap() },
                    onDoubleTap = { offset -> onDoubleTap?.invoke(offset) }
                )
            }
    ) {
        if (hasError) {
            Log.w("VideoPlayer", "🎥 Showing error UI: $errorMessage")
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Black),
                contentAlignment = Alignment.Center
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.PlayArrow,
                        contentDescription = "Video Error",
                        tint = Color.White,
                        modifier = Modifier.size(48.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Video unavailable",
                        color = Color.White,
                        fontSize = 18.sp,
                        textAlign = TextAlign.Center
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = errorMessage,
                        color = Color.Gray,
                        fontSize = 12.sp,
                        textAlign = TextAlign.Center
                    )
                }
            }
        } else {
            Log.d("VideoPlayer", "🎥 Rendering AndroidView for ExoPlayer")
            AndroidView(
                factory = { context ->
                    Log.d("VideoPlayer", "🎥 Creating AndroidView factory")
                    PlayerView(context).apply {
                        useController = false // HIDE ALL DEFAULT CONTROLS
                        setShowBuffering(SHOW_BUFFERING_ALWAYS)
                        Log.d("VideoPlayer", "🎥 PlayerView created")
                    }
                },
                modifier = Modifier.fillMaxSize(),
                update = { playerView ->
                    Log.d("VideoPlayer", "🎥 Updating PlayerView with ExoPlayer")
                    exoPlayer?.let { player ->
                        playerView.player = player
                        Log.d("VideoPlayer", "🎥 PlayerView updated with ExoPlayer")
                    }
                }
            )

            // Show loading indicator
            if (isLoading) {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(Color.Black.copy(alpha = 0.5f)),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator(
                        color = Color.White,
                        modifier = Modifier.size(32.dp)
                    )
                }
            }

            if (showPlayButton && !isLoading && !isPlayerPlaying) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.PlayArrow,
                        contentDescription = "Play",
                        tint = Color.White.copy(alpha = 0.8f),
                        modifier = Modifier.size(64.dp)
                    )
                }
            }
        }
    }
}

