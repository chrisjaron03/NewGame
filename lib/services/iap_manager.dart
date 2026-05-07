import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';

class IAPManager {
  static final IAPManager _instance = IAPManager._internal();
  factory IAPManager() => _instance;
  IAPManager._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final String _removeAdsId = 'remove_ads'; // Replace with real PlayStore ID later

  bool _isAvailable = false;
  List<ProductDetails> products = [];

  Function? onAdsRemoved;

  Future<void> init(Function onAdsRemovedCallback) async {
    onAdsRemoved = onAdsRemovedCallback;
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // Handle error here.
    });

    _isAvailable = await _inAppPurchase.isAvailable();
    if (_isAvailable) {
      ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails({_removeAdsId});
      if (productDetailResponse.error == null) {
        products = productDetailResponse.productDetails;
      }
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          if (purchaseDetails.productID == _removeAdsId) {
             onAdsRemoved?.call();
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void buyRemoveAds() {
    if (products.isNotEmpty) {
      final ProductDetails productDetails = products.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  void dispose() {
    _subscription.cancel();
  }
}
