import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintribe/features/auth/ui/login/login_state.dart';

/// Screen-specific provider for the login form.
class LoginForm extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setEmail(String v) => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);
  void toggleObscure() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);
  void reset() => state = const LoginState();
}

final loginFormProvider = NotifierProvider<LoginForm, LoginState>(
  LoginForm.new,
);
