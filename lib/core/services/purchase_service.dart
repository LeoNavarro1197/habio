import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseServiceHolder {
  static final PurchaseService instance = PurchaseService();
}

class PurchaseService {
  static const String premiumProductId = 'remove_ads';

  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = false;
  ProductDetails? _premiumProduct;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool get isAvailable => _available;
  ProductDetails? get premiumProduct => _premiumProduct;
  String? get premiumPriceLabel => _premiumProduct?.price;

  VoidCallback? onPurchaseComplete;

  Future<void> initialize() async {
    try {
      _available = await _iap.isAvailable();
    } catch (_) {
      _available = false;
    }

    if (!_available) return;

    _subscription = _iap.purchaseStream.listen(_handlePurchaseUpdates);

    final response = await _iap.queryProductDetails({premiumProductId});
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('[Habio] Producto no encontrado: ${response.notFoundIDs}');
    }
    if (response.productDetails.isNotEmpty) {
      _premiumProduct = response.productDetails.first;
    }
  }

  Future<bool> buyPremium() async {
    if (!_available || _premiumProduct == null) return false;

    try {
      await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: _premiumProduct!),
      );
      return true;
    } catch (err) {
      debugPrint('[Habio] Error al iniciar compra: $err');
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    if (!_available) return false;

    try {
      await _iap.restorePurchases();
      return true;
    } catch (err) {
      debugPrint('[Habio] Error al restaurar compras: $err');
      return false;
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == premiumProductId) {
          onPurchaseComplete?.call();
        }
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
