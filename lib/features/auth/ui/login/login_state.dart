/// Immutable login form state — kept separate from the provider.
class LoginState {
  const LoginState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
  });

  final String email;
  final String password;
  final bool obscurePassword;

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
  }) => LoginState(
    email: email ?? this.email,
    password: password ?? this.password,
    obscurePassword: obscurePassword ?? this.obscurePassword,
  );
}
