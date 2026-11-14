import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Listens to admin-controlled tables. Any admin edit reaches the app instantly.
class SettingsService {
  SettingsService._();
  static final instance = SettingsService._();

  final rates = ValueNotifier<List<Map<String, dynamic>>>([]);
  final paymentMethods = ValueNotifier<List<Map<String, dynamic>>>([]);
  final _db = Supabase.instance.client;

  void start() {
    _db.from('commission_rates').stream(primaryKey: ['ad_type']).listen((rows) => rates.value = rows);
    _db
        .from('payment_methods')
        .stream(primaryKey: ['id'])
        .eq('enabled', true)
        .listen((rows) => paymentMethods.value = rows);
  }

  /// Returns {seller_pct, buyer_pct, enabled} for an ad type such as 'sell'.
  Map<String, dynamic>? rateFor(String adType) {
    for (final r in rates.value) {
      if (r['ad_type'] == adType) return r;
    }
    return null;
  }
}
