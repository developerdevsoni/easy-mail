import 'dart:convert';
import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForceUpdateService {
  static final ForceUpdateService _instance = ForceUpdateService._internal();
  factory ForceUpdateService() => _instance;
  ForceUpdateService._internal();

  FirebaseRemoteConfig? _remoteConfig;
  PackageInfo? _packageInfo;

  // Initialize the service
  Future<void> initialize() async {
    try {
      print('🔍 DEBUG: Initializing ForceUpdateService...');
      _remoteConfig = FirebaseRemoteConfig.instance;
      _packageInfo = await PackageInfo.fromPlatform();
      print('🔍 DEBUG: Package info loaded - Version: ${_packageInfo!.version}');
      
      await _setupRemoteConfig();
      print('🔍 DEBUG: ForceUpdateService initialized successfully');
    } catch (e) {
      print('❌ ERROR: Force Update Service initialization failed: $e');
    }
  }

  // Setup Firebase Remote Config
  Future<void> _setupRemoteConfig() async {
    if (_remoteConfig == null) return;

    print('🔍 DEBUG: Setting up Remote Config...');

    await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: Duration.zero, // For testing - set to 0 to always fetch
    ));

    // Set default values
    await _remoteConfig!.setDefaults({
      'ForceUpdate': jsonEncode({
        'ios': {
          'current_version': '1.0.0',
          'minimum_required_version': '1.0.0',
          'force_update': false,
          'show_update': false,
          'store_url': 'https://apps.apple.com/app/id123456789',
          'update_title': 'Update Available',
          'update_message': 'A new version is available. Please update to continue using the app.',
          'force_update_title': 'Update Required',
          'force_update_message': 'This version is no longer supported. Please update to continue.',
          'update_button_text': 'Update Now',
          'later_button_text': 'Later',
          'changelog': [
            'Bug fixes and improvements',
            'Enhanced user experience',
            'New features added'
          ]
        },
        'android': {
          'current_version': '1.0.0',
          'minimum_required_version': '1.0.0',
          'force_update': false,
          'show_update': false,
          'store_url': 'https://play.google.com/store/apps/details?id=com.easyMail.easy_mail',
          'update_title': 'Update Available',
          'update_message': 'A new version is available. Please update to continue using the app.',
          'force_update_title': 'Update Required',
          'force_update_message': 'This version is no longer supported. Please update to continue.',
          'update_button_text': 'Update Now',
          'later_button_text': 'Later',
          'changelog': [
            'Bug fixes and improvements',
            'Enhanced user experience',
            'New features added'
          ]
        }
      }),
    });

    try {
      print('🔍 DEBUG: Fetching remote config...');
      final success = await _remoteConfig!.fetchAndActivate();
      print('🔍 DEBUG: Remote config fetch success: $success');
      
      // Test if we can get the config
      final testConfig = _remoteConfig!.getString('ForceUpdate');
      print('🔍 DEBUG: Test config retrieval: ${testConfig.substring(0, 100)}...');
      
    } catch (e) {
      print('❌ ERROR: Failed to fetch remote config: $e');
    }
  }

  // Check if update is required
  Future<UpdateStatus> checkForUpdate() async {
    if (_remoteConfig == null || _packageInfo == null) {
      await initialize();
    }

    try {
      print('🔍 DEBUG: Starting update check...');
      
      final configJson = _remoteConfig!.getString('ForceUpdate');
      print('🔍 DEBUG: Raw config JSON: $configJson');
      
      final config = jsonDecode(configJson);
      print('🔍 DEBUG: Parsed config: $config');
      
      final platform = Platform.isIOS ? 'ios' : 'android';
      final platformConfig = config[platform];
      print('🔍 DEBUG: Platform: $platform, Config: $platformConfig');
      
      if (platformConfig == null) {
        print('🔍 DEBUG: No platform config found');
        return UpdateStatus.noUpdate;
      }

      final currentVersion = _packageInfo!.version;
      final minimumVersion = platformConfig['minimum_required_version'] as String;
      final latestVersion = platformConfig['current_version'] as String;
      final forceUpdate = platformConfig['force_update'] as bool;
      final showUpdate = platformConfig['show_update'] as bool;

      print('🔍 DEBUG: Current version: $currentVersion');
      print('🔍 DEBUG: Minimum version: $minimumVersion');
      print('🔍 DEBUG: Latest version: $latestVersion');
      print('🔍 DEBUG: Force update: $forceUpdate');
      print('🔍 DEBUG: Show update: $showUpdate');

      // Check if current version is below minimum required
      if (_isVersionLower(currentVersion, minimumVersion)) {
        print('🔍 DEBUG: Current version below minimum - Force update required');
        return UpdateStatus.forceUpdate;
      }

      // Check if update is available and should be shown
      if (showUpdate && _isVersionLower(currentVersion, latestVersion)) {
        final status = forceUpdate ? UpdateStatus.forceUpdate : UpdateStatus.normalUpdate;
        print('🔍 DEBUG: Update available - Status: $status');
        return status;
      }

      print('🔍 DEBUG: No update required');
      return UpdateStatus.noUpdate;
    } catch (e) {
      print('❌ ERROR: Error checking for update: $e');
      return UpdateStatus.noUpdate;
    }
  }

  // Get update configuration
  Map<String, dynamic>? getUpdateConfig() {
    if (_remoteConfig == null) return null;

    try {
      final configJson = _remoteConfig!.getString('ForceUpdate');
      final config = jsonDecode(configJson);
      final platform = Platform.isIOS ? 'ios' : 'android';
      return config[platform];
    } catch (e) {
      print('Error getting update config: $e');
      return null;
    }
  }

  // Compare version strings (e.g., "1.2.3" vs "1.2.4")
  bool _isVersionLower(String current, String target) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> targetParts = target.split('.').map(int.parse).toList();

    // Normalize lengths
    while (currentParts.length < targetParts.length) {
      currentParts.add(0);
    }
    while (targetParts.length < currentParts.length) {
      targetParts.add(0);
    }

    for (int i = 0; i < currentParts.length; i++) {
      if (currentParts[i] < targetParts[i]) {
        return true;
      } else if (currentParts[i] > targetParts[i]) {
        return false;
      }
    }
    return false;
  }

  // Get current app version
  String getCurrentVersion() {
    return _packageInfo?.version ?? '1.0.0';
  }

  // Get app name
  String getAppName() {
    return _packageInfo?.appName ?? 'Easy Mail';
  }

  // Test method to force refresh config
  Future<void> forceRefreshConfig() async {
    try {
      print('🔍 DEBUG: Force refreshing config...');
      
      // Reset config settings to ensure fresh fetch
      await _remoteConfig?.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Duration.zero,
      ));
      
      await _remoteConfig?.fetchAndActivate();
      print('🔍 DEBUG: Config refreshed successfully');
      
      // Test the new config
      final testConfig = _remoteConfig?.getString('ForceUpdate') ?? '';
      print('🔍 DEBUG: New config after refresh: ${testConfig.substring(0, 200)}...');
      
    } catch (e) {
      print('❌ ERROR: Failed to refresh config: $e');
    }
  }
}

enum UpdateStatus {
  noUpdate,
  normalUpdate,
  forceUpdate,
} 