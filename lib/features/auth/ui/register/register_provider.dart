import 'package:fintribe/features/auth/ui/register/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen-scoped provider for the register form.
class RegisterForm extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  void setName(String v) => state = state.copyWith(name: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);
  void toggleObscure() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);
  void setAgree(bool v) => state = state.copyWith(agreeToTerms: v);
  void reset() => state = const RegisterState();
}

final registerFormProvider = NotifierProvider<RegisterForm, RegisterState>(
  RegisterForm.new,
);
