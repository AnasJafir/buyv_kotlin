import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/app_config.dart';
import 'presentation/router/app_router.dart';
import 'presentation/providers/settings_provider.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Hive — offline-first storage (cart, preferences)
  await Hive.initFlutter();
  await Hive.openBox(AppConfig.cartBoxName);
  await Hive.openBox(AppConfig.prefsBoxName);
  await Hive.openBox(AppConfig.recentlyViewedBoxName);

  // Stripe
  Stripe.publishableKey = AppConfig.stripePublishableKey;
  await Stripe.instance.applySettings();

  // Firebase (FlutterFire) — initialized only once
  // Uncomment after running `flutterfire configure`:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // ProviderScope wraps the entire app — provides Riverpod to all descendants
    const ProviderScope(child: BuyVApp()),
  );
}

class BuyVApp extends ConsumerWidget {
  const BuyVApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: Locale(settings.languageCode),
      supportedLocales: const <Locale>[
        Locale('fr'),
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        // Enforce text scale factor across all platforms
        final clampedTextScaler = MediaQuery.of(context)
            .textScaler
            .clamp(minScaleFactor: 0.85, maxScaleFactor: 1.1);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: clampedTextScaler,
          ),
          child: child!,
        );
      },
    );
  }
}
