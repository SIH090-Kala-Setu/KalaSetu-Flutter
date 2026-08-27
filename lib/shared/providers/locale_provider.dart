import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/storage_providers.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final storage = ref.read(localStorageProvider);
    final langCode = storage.getLanguage();
    return Locale(langCode);
  }

  Future<void> setLocale(String languageCode) async {
    final storage = ref.read(localStorageProvider);
    await storage.setLanguage(languageCode);
    state = Locale(languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
