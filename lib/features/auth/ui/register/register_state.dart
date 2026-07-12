/// Immutable register-form state.
class RegisterState {
  const RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.agreeToTerms = false,
  });

  final String name;
  final String email;
  final String password;
  final bool obscurePassword;
  final bool agreeToTerms;

  /// Password strength on a 0–4 scale (length, uppercase, digit, symbol/long).
  int get passwordStrength {
    if (password.isEmpty) return 0;
    var score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[^A-Za-z0-9]')) || password.length >= 12) {
      score++;
    }
    return score;
  }

  /// Whether the form is minimally complete enough to submit.
  bool get canSubmit =>
      agreeToTerms &&
      name.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      password.isNotEmpty;

  RegisterState copyWith({
    String? name,
    String? email,
    String? password,
    bool? obscurePassword,
    bool? agreeToTerms,
  }) => RegisterState(
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    obscurePassword: obscurePassword ?? this.obscurePassword,
    agreeToTerms: agreeToTerms ?? this.agreeToTerms,
  );
}
