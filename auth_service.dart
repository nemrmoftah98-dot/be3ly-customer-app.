import 'package:supabase_flutter/supabase_flutter.dart';

/// Phone number + password. No SMS, no cost. The phone is the username only (not verified).
/// Internally Supabase email auth is used with a synthetic email built from the phone number.
/// In Supabase: Authentication > Providers > Email: turn OFF "Confirm email".
class AuthService {
  AuthService._();
  static final instance = AuthService._();
  final _auth = Supabase.instance.client.auth;

  bool get isLoggedIn => _auth.currentSession != null;

  /// Accepts 01012345678 / +201012345678 / 00201012345678. Returns +20XXXXXXXXXX or null.
  static String? normalizeEgyptPhone(String input) {
    var d = input.replaceAll(RegExp(r'[^0-9+]'), '');
    if (d.startsWith('+20')) d = d.substring(3);
    else if (d.startsWith('0020')) d = d.substring(4);
    else if (d.startsWith('0')) d = d.substring(1);
    return RegExp(r'^1[0125]\d{8}$').hasMatch(d) ? '+20$d' : null;
  }

  static String _email(String phone) => '${phone.substring(1)}@phone.be3ly.app';

  Future<void> register({required String phone, required String password, required String name, required String governorate}) =>
      _auth.signUp(email: _email(phone), password: password, data: {'phone': phone, 'full_name': name, 'governorate': governorate});

  Future<void> login(String phone, String password) => _auth.signInWithPassword(email: _email(phone), password: password);

  Future<void> signOut() => _auth.signOut();
}
