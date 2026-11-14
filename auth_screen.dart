import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';

const governorates = ['القاهرة', 'الجيزة', 'الإسكندرية', 'الدقهلية', 'الشرقية', 'القليوبية', 'الغربية', 'المنوفية', 'البحيرة', 'الفيوم', 'بني سويف', 'المنيا', 'أسيوط', 'سوهاج', 'قنا', 'الأقصر', 'أسوان', 'أخرى'];

/// Call before any action that needs an account (post ad, contact, confirm deal).
/// Browsing and search stay open without it.
Future<bool> requireLogin(BuildContext context) async {
  if (AuthService.instance.isLoggedIn) return true;
  final ok = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
  return ok == true;
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phone = TextEditingController(), _pw = TextEditingController(), _name = TextEditingController();
  bool _register = false, _busy = false;
  String? _gov, _err;

  Future<void> _submit() async {
    final phone = AuthService.normalizeEgyptPhone(_phone.text);
    if (phone == null) return setState(() => _err = 'اكتب رقم موبايل مصري صحيح (مثال: 01012345678)');
    if (_pw.text.length < 6) return setState(() => _err = 'كلمة المرور 6 أحرف أو أرقام على الأقل');
    if (_register && (_name.text.trim().length < 3 || _gov == null)) return setState(() => _err = 'اكتب اسمك واختر المحافظة');
    setState(() { _busy = true; _err = null; });
    try {
      if (_register) {
        await AuthService.instance.register(phone: phone, password: _pw.text, name: _name.text.trim(), governorate: _gov!);
      } else {
        await AuthService.instance.login(phone, _pw.text);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      final m = e.toString().toLowerCase();
      setState(() => _err = m.contains('already') || m.contains('duplicate')
          ? 'هذا الرقم مسجل بالفعل، سجّل الدخول'
          : _register ? 'تعذر إنشاء الحساب' : 'الرقم أو كلمة المرور غير صحيحة');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(_register ? 'إنشاء حساب' : 'تسجيل الدخول')),
        body: ListView(padding: const EdgeInsets.all(24), children: [
          Center(child: ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/logo-512.png', width: 110))),
          const SizedBox(height: 8),
          const Center(child: Text('بعلي.. سوقك في مكان واحد', style: TextStyle(fontWeight: FontWeight.w800, color: green))),
          const SizedBox(height: 16),
          if (_register) ...[
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'الاسم', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'المحافظة', border: OutlineInputBorder()),
              items: [for (final g in governorates) DropdownMenuItem(value: g, child: Text(g))],
              onChanged: (v) => setState(() => _gov = v),
            ),
            const SizedBox(height: 10),
          ],
          TextField(controller: _phone, keyboardType: TextInputType.phone, textDirection: TextDirection.ltr,
              decoration: const InputDecoration(labelText: 'رقم الموبايل', prefixText: '+20 ', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _pw, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور', border: OutlineInputBorder())),
          if (_err != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_err!, style: const TextStyle(color: Colors.red))),
          const SizedBox(height: 14),
          FilledButton(onPressed: _busy ? null : _submit, child: Text(_busy ? 'لحظة...' : _register ? 'إنشاء الحساب' : 'دخول')),
          TextButton(onPressed: () => setState(() { _register = !_register; _err = null; }),
              child: Text(_register ? 'عندي حساب، تسجيل الدخول' : 'ليس لدي حساب، إنشاء حساب')),
        ]),
      );
}
