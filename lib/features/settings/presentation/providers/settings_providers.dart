import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/services/ads_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/purchase_service.dart';
import '../../../../core/storage/hive_boxes.dart';

class SettingsState {
  const SettingsState({
    required this.notificationsEnabled,
    required this.adsRemoved,
  });

  final bool notificationsEnabled;
  final bool adsRemoved;

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? adsRemoved,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      adsRemoved: adsRemoved ?? this.adsRemoved,
    );
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationServiceHolder.instance;
});

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return PurchaseServiceHolder.instance;
});

final adsServiceProvider = Provider<AdsService>((ref) {
  return AdsServiceHolder.instance;
});

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  final box = Hive.box<dynamic>(HiveBoxes.settings);
  return SettingsController(
    box: box,
    notificationService: ref.watch(notificationServiceProvider),
    purchaseService: ref.watch(purchaseServiceProvider),
  );
});

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController({
    required Box<dynamic> box,
    required NotificationService notificationService,
    required PurchaseService purchaseService,
  })  : _box = box,
        _notificationService = notificationService,
        _purchaseService = purchaseService,
        super(
          SettingsState(
            notificationsEnabled:
                box.get(_notificationsEnabledKey, defaultValue: true) as bool,
            adsRemoved: box.get(_adsRemovedKey, defaultValue: false) as bool,
          ),
        ) {
    _notificationService.updateEnabledSetting(state.notificationsEnabled);
    _initPurchaseService();
  }

  Future<void> _initPurchaseService() async {
    _purchaseService.onPurchaseComplete = _onPurchaseComplete;
    await _purchaseService.initialize();
    if (_purchaseService.premiumProduct != null) {
      _productLoaded = true;
    }
  }

  bool _productLoaded = false;
  bool get isProductLoaded => _productLoaded;
  String? get premiumPriceLabel => _purchaseService.premiumPriceLabel;
  bool get isPurchaseAvailable => _purchaseService.isAvailable;

  void _onPurchaseComplete() {
    _markAdsRemoved();
  }

  Future<void> _markAdsRemoved() async {
    await _box.put(_adsRemovedKey, true);
    state = state.copyWith(adsRemoved: true);
  }

  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _adsRemovedKey = 'ads_removed';

  final Box<dynamic> _box;
  final NotificationService _notificationService;
  final PurchaseService _purchaseService;

  Future<void> toggleNotifications(bool enabled) async {
    await _notificationService.setEnabled(enabled);
    await _box.put(_notificationsEnabledKey, enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }

  Future<bool> buyPremium() async {
    return _purchaseService.buyPremium();
  }

  Future<void> restorePurchases() async {
    await _purchaseService.restorePurchases();
    final adsRemoved = _box.get(_adsRemovedKey, defaultValue: false) as bool;
    state = state.copyWith(adsRemoved: adsRemoved);
  }
}
