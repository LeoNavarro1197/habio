import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habio/core/services/notification_service.dart';
import 'package:habio/core/services/purchase_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:habio/features/settings/presentation/providers/settings_providers.dart';
import '../helpers/hive_test_helper.dart';

class _MockNotificationService extends NotificationService {
  bool enabledValue = true;

  @override
  Future<void> setEnabled(bool value) async {
    enabledValue = value;
  }

  @override
  void updateEnabledSetting(bool value) {
    enabledValue = value;
  }
}

class _MockPurchaseService implements PurchaseService {
  bool _initialized = false;
  bool _buyPremiumResult = true;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  ProductDetails? get premiumProduct => null;

  @override
  String? get premiumPriceLabel => null;

  @override
  bool get isAvailable => true;

  @override
  Future<bool> buyPremium() async => _buyPremiumResult;

  @override
  Future<bool> restorePurchases() async => true;

  @override
  VoidCallback? onPurchaseComplete;

  @override
  void dispose() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SettingsController', () {
    late Box<dynamic> box;
    late _MockNotificationService mockNotif;
    late _MockPurchaseService mockPurchase;

    setUpAll(() async {
      await HiveTestHelper.init();
    });

    tearDownAll(() async {
      await HiveTestHelper.cleanUp();
    });

    setUp(() async {
      box = await Hive.openBox<dynamic>('settings_test');
      mockNotif = _MockNotificationService();
      mockPurchase = _MockPurchaseService();
    });

    tearDown(() async {
      await box.close();
    });

    test('initial state reads from box with defaults', () {
      final controller = SettingsController(
        box: box,
        notificationService: mockNotif,
        purchaseService: mockPurchase,
      );

      expect(controller.state.notificationsEnabled, isTrue);
      expect(controller.state.adsRemoved, isFalse);
      controller.dispose();
    });

    test('toggleNotifications updates state and persists', () async {
      final controller = SettingsController(
        box: box,
        notificationService: mockNotif,
        purchaseService: mockPurchase,
      );

      await controller.toggleNotifications(false);
      expect(controller.state.notificationsEnabled, isFalse);
      expect(mockNotif.enabledValue, isFalse);

      final stored = box.get('notifications_enabled', defaultValue: true);
      expect(stored, isFalse);

      controller.dispose();
    });

    test('toggleNotifications re-enables', () async {
      final controller = SettingsController(
        box: box,
        notificationService: mockNotif,
        purchaseService: mockPurchase,
      );

      await controller.toggleNotifications(true);
      expect(controller.state.notificationsEnabled, isTrue);
      expect(mockNotif.enabledValue, isTrue);

      controller.dispose();
    });

    test('restorePurchases reads ads_removed from box', () async {
      await box.put('ads_removed', true);

      final controller = SettingsController(
        box: box,
        notificationService: mockNotif,
        purchaseService: mockPurchase,
      );

      await controller.restorePurchases();
      expect(controller.state.adsRemoved, isTrue);

      controller.dispose();
    });
  });
}
