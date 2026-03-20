/// Fix for Bug #4 (UPLOAD-002): HTML content injected into captions / product descriptions.
/// Replicates KMP's HtmlSanitizer.kt from the shared module.
class HtmlSanitizer {
  HtmlSanitizer._();

  /// Strip all HTML tags, return plain text.
  /// Preserves newlines from <br> tags.
  static String stripTags(String html) {
    if (html.isEmpty) return html;
    return html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<img[^>]*>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .trim();
  }

  /// Strip HTML but keep bold markers as asterisks (like Markdown).
  static String toReadableText(String html) {
    if (html.isEmpty) return html;
    return html
        .replaceAll(RegExp(r'<b[^>]*>(.*?)</b>', caseSensitive: false), '*\$1*')
        .replaceAll(RegExp(r'<strong[^>]*>(.*?)</strong>', caseSensitive: false), '*\$1*')
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<img[^>]*>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  /// Extract image URLs from HTML <img src="..."> tags.
  static List<String> extractImageUrls(String html) {
    final regex = RegExp(r'src="([^"]+)"', caseSensitive: false);
    return regex
        .allMatches(html)
        .map((m) => m.group(1) ?? '')
        .where((url) => url.isNotEmpty && (url.startsWith('http')))
        .toList();
  }

  /// Remove problematic Unicode (U+FFFC Object Replacement Character — Bug UI-003).
  static String removeObjectReplacementChars(String text) =>
      text.replaceAll('\uFFFC', '').replaceAll('\uFFFD', '');
}
