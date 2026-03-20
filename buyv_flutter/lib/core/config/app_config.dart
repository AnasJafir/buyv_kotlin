/// BuyV App — Environment Configuration
/// Maps to ApiEnvironment.kt in the KMP shared module.
class AppConfig {
  AppConfig._();

  // ── API Base URLs ───────────────────────────────────────────────
  static const String devBaseUrl = 'http://192.168.11.109:8000';
  static const String railwayBaseUrl =
      'https://buyvkotlin-production.up.railway.app';

  /// Toggle between dev and production.
  /// Set to true before release build.
  static const bool isProduction = false;

  static String get baseUrl => isProduction ? railwayBaseUrl : devBaseUrl;

  // ── Timeouts ────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ── Cloudinary ──────────────────────────────────────────────────
  static const String cloudinaryCloudName = 'dhzllfeno';
  static const String cloudinaryUploadPreset = 'Ecommerce_BuyV';
  static const String cloudinaryBaseUrl =
      'https://api.cloudinary.com/v1_1/dhzllfeno';

  // ── Stripe ──────────────────────────────────────────────────────
  static const String stripePublishableKey =
      'pk_test_51ShsRTAXpOslilN9YUGZ3CIHPUTFGcv3KifRRgIVgMRbGtju1lmNIiSt3INy2rm3puYHWmhnM16bh71Z1AMQRi4Q00IbbDYZtJ';

  // ── App Constants ───────────────────────────────────────────────
  static const String appName = 'BuyV';
  static const String appVersion = '1.0.0';

  // ── Hive Box Names ──────────────────────────────────────────────
  static const String cartBoxName = 'cart';
  static const String prefsBoxName = 'prefs';
  static const String recentlyViewedBoxName = 'recently_viewed';

  // ── Debug ───────────────────────────────────────────────────────
  static const bool enableNetworkLogs = !isProduction;
}
