import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../core/config/app_config.dart';

class AppSettings {
  const AppSettings({
    required this.notificationsEnabled,
    required this.reelsAutoplay,
    required this.useMobileData,
    required this.biometricLock,
    required this.languageCode,
  });

  final bool notificationsEnabled;
  final bool reelsAutoplay;
  final bool useMobileData;
  final bool biometricLock;
  final String languageCode;

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? reelsAutoplay,
    bool? useMobileData,
    bool? biometricLock,
    String? languageCode,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reelsAutoplay: reelsAutoplay ?? this.reelsAutoplay,
      useMobileData: useMobileData ?? this.useMobileData,
      biometricLock: biometricLock ?? this.biometricLock,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

class SettingsNotifier extends Notifier<AppSettings> {
  static const String _notificationsKey = 'settings_notifications_enabled';
  static const String _reelsAutoplayKey = 'settings_reels_autoplay';
  static const String _useMobileDataKey = 'settings_use_mobile_data';
  static const String _biometricLockKey = 'settings_biometric_lock';
  static const String _languageCodeKey = 'settings_language_code';

  @override
  AppSettings build() {
    final box = Hive.box(AppConfig.prefsBoxName);
    return AppSettings(
      notificationsEnabled: box.get(_notificationsKey, defaultValue: true) == true,
      reelsAutoplay: box.get(_reelsAutoplayKey, defaultValue: true) == true,
      useMobileData: box.get(_useMobileDataKey, defaultValue: true) == true,
      biometricLock: box.get(_biometricLockKey, defaultValue: false) == true,
      languageCode: (box.get(_languageCodeKey, defaultValue: 'fr') as String?)?.trim().isNotEmpty == true
          ? (box.get(_languageCodeKey, defaultValue: 'fr') as String).trim()
          : 'fr',
    );
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _update(state.copyWith(notificationsEnabled: value));
  }

  Future<void> setReelsAutoplay(bool value) async {
    await _update(state.copyWith(reelsAutoplay: value));
  }

  Future<void> setUseMobileData(bool value) async {
    await _update(state.copyWith(useMobileData: value));
  }

  Future<void> setBiometricLock(bool value) async {
    await _update(state.copyWith(biometricLock: value));
  }

  Future<void> setLanguageCode(String value) async {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) {
      return;
    }
    await _update(state.copyWith(languageCode: normalized));
  }

  Future<void> _update(AppSettings next) async {
    state = next;
    final box = Hive.box(AppConfig.prefsBoxName);
    await box.put(_notificationsKey, next.notificationsEnabled);
    await box.put(_reelsAutoplayKey, next.reelsAutoplay);
    await box.put(_useMobileDataKey, next.useMobileData);
    await box.put(_biometricLockKey, next.biometricLock);
    await box.put(_languageCodeKey, next.languageCode);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
