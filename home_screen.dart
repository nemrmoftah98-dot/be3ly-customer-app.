import 'package:flutter/material.dart';
import '../main.dart';
import 'auth_screen.dart';
import 'pledge_sheet.dart';

const _cats = [
  ['🚗', 'السيارات'], ['🏠', 'العقارات'], ['📱', 'الموبايلات'], ['🔌', 'الأجهزة الكهربائية'],
  ['🛋️', 'الأثاث والمنزل'], ['👕', 'الملابس'], ['🧸', 'الأطفال'], ['🐑', 'الحيوانات'],
  ['🛠️', 'المعدات'], ['💼', 'الوظائف'], ['🔧', 'الخدمات'], ['📚', 'الدروس'],
  ['🌾', 'الزراعة'], ['🏪', 'المشروعات'], ['📦', 'متنوعات'],
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(children: [
          Container(
            color: green,
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/logo-192.png', width: 42, height: 42)),
              const SizedBox(width: 10),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: orange),
                onPressed: () => requireLogin(context), // TODO: open add-ad form after login
                child: const Text('+ أضف إعلانك'),
              ),
              const Spacer(),
              const Text('📍 القاهرة ▾', style: TextStyle(color: Colors.white)),
              IconButton(icon: const Icon(Icons.person, color: Colors.white), onPressed: () => requireLogin(context)),
            ]),
          ),
          Container(
            color: cs.surfaceContainerHighest.withOpacity(.4),
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/logo-512.png', width: 104)),
              const Text('بيع • شراء • إيجار • خدمات • مقايضة'),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: TextField(decoration: InputDecoration(hintText: 'بتدور على إيه؟', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
                const SizedBox(width: 8),
                FilledButton(onPressed: () {}, child: const Text('بحث')),
              ]),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('الأقسام الرئيسية', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.05,
                children: [
                  for (final c in _cats)
                    InkWell(
                      onTap: () async {
                        if (await requireLogin(context) && context.mounted) showPledgeSheet(context, adType: 'sell', price: 10000);
                      }, // demo hook
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: cs.outlineVariant), borderRadius: BorderRadius.circular(14)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(c[0], style: const TextStyle(fontSize: 28)),
                          Text(c[1], textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                ],
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
