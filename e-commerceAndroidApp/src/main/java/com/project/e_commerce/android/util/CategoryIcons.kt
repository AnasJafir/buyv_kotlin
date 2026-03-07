package com.project.e_commerce.android.util

import com.project.e_commerce.android.R

/**
 * CAT-001/005: Maps category slugs (from backend) to local drawable resource IDs.
 *
 * Falls back to [R.drawable.buyv_logo] when no slug match is found,
 * ensuring the UI always shows something meaningful.
 *
 * Usage:
 * ```kotlin
 * val icon = CategoryIcons.forSlug(category.slug)
 * Image(painter = painterResource(icon), contentDescription = category.name)
 * ```
 */
object CategoryIcons {

    /** @return Android drawable resource ID for the given [slug]. */
    fun forSlug(slug: String): Int = slugToDrawable[slug.lowercase().trim()]
        ?: R.drawable.buyv_logo

    // slug → drawable mapping — extend as categories grow in the backend
    private val slugToDrawable: Map<String, Int> = mapOf(
        // Fashion & Clothing
        "fashion"           to R.drawable.ic_star,
        "clothing"          to R.drawable.ic_star,
        "women-fashion"     to R.drawable.ic_star,
        "men-fashion"       to R.drawable.ic_star,
        // Electronics
        "electronics"       to R.drawable.ic_video,
        "phones"            to R.drawable.ic_video,
        "computers"         to R.drawable.ic_video,
        // Beauty
        "beauty"            to R.drawable.ic_smiley,
        "skincare"          to R.drawable.ic_smiley,
        "makeup"            to R.drawable.ic_smiley,
        // Home
        "home"              to R.drawable.ic_setting,
        "furniture"         to R.drawable.ic_setting,
        "kitchen"           to R.drawable.ic_setting,
        // Sports
        "sports"            to R.drawable.ic_heart_checked,
        "fitness"           to R.drawable.ic_heart_checked,
        // Accessories
        "accessories"       to R.drawable.ic_star,
        "jewelry"           to R.drawable.ic_star,
        "watches"           to R.drawable.ic_star,
        // Food & Grocery
        "food"              to R.drawable.ic_smiley,
        "grocery"           to R.drawable.ic_smiley,
        // Toys & Kids
        "toys"              to R.drawable.ic_smiley,
        "kids"              to R.drawable.ic_smiley,
        "baby"              to R.drawable.ic_smiley
    )
}
