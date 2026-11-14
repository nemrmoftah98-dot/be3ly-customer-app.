import 'package:flutter/material.dart';
import '../services/settings_service.dart';

/// Commission pledge. Rates come live from the admin-controlled table.
Future<bool?> showPledgeSheet(BuildContext context, {required String adType, required double price}) {
  return showModalBottomSheet<bool>(
    context: context,
    builder: (_) => ValueListenableBuilder(
      valueListenable: SettingsService.instance.rates,
      builder: (ctx, _, __) {
        final r = SettingsService.instance.rateFor(adType);
        final s = (r?['seller_pct'] ?? 0).toDouble(), b = (r?['buyer_pct'] ?? 0).toDouble();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('تعهد العمولة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            Text('نسبة المشتري: $b٪ = ${(price * b / 100).toStringAsFixed(2)} ج.م'),
            Text('نسبة البائع: $s٪ = ${(price * s / 100).toStringAsFixed(2)} ج.م'),
            const SizedBox(height: 8),
            const Text('أتعهد بدفع عمولة بعلي عند إتمام الصفقة وتأكيدها، على السعر المكتوب في الإعلان.'),
            // TODO: insert into commission_pledges with snapshot of rates, then open chat
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('أوافق وأبدأ المحادثة')),
          ]),
        );
      },
    ),
  );
}
