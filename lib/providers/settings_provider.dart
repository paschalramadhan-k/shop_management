import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  AppSettings? _settings;

  AppSettings? get settings => _settings;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  //=========================================
  // Load Settings
  //=========================================
  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _settings = await _settingsService.getSettings();

    _isLoading = false;
    notifyListeners();
  }

  //=========================================
  // Save All Settings
  //=========================================
  Future<void> saveSettings(
      AppSettings settings,
      ) async {
    await _settingsService.updateSettings(settings);

    _settings = settings;

    notifyListeners();
  }

  //=========================================
  // Reset Settings
  //=========================================
  Future<void> resetSettings() async {
    await _settingsService.resetSettings();

    await loadSettings();
  }

  //=========================================
  // Update Currency
  //=========================================
  Future<void> updateCurrency(
      String currency,
      ) async {
    if (_settings == null) return;

    await _settingsService.updateCurrency(currency);

    _settings = _settings!.copyWith(
      currency: currency,
    );

    notifyListeners();
  }

  //=========================================
  // Update Theme
  //=========================================
  Future<void> updateTheme(
      String theme,
      ) async {
    if (_settings == null) return;

    await _settingsService.updateTheme(theme);

    _settings = _settings!.copyWith(
      theme: theme,
    );

    notifyListeners();
  }

  //=========================================
  // Update Tax Rate
  //=========================================
  Future<void> updateTaxRate(
      double taxRate,
      ) async {
    if (_settings == null) return;

    await _settingsService.updateTaxRate(
      taxRate,
    );

    _settings = _settings!.copyWith(
      taxRate: taxRate,
    );

    notifyListeners();
  }

  //=========================================
  // Update Low Stock Limit
  //=========================================
  Future<void> updateLowStockLimit(
      int limit,
      ) async {
    if (_settings == null) return;

    await _settingsService.updateLowStockLimit(
      limit,
    );

    _settings = _settings!.copyWith(
      lowStockLimit: limit,
    );

    notifyListeners();
  }

  //=========================================
  // Refresh Settings
  //=========================================
  Future<void> refresh() async {
    await loadSettings();
  }
}