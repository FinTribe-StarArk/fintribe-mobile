import 'package:fintribe/core/constants/ui_constants.dart';
import 'package:fintribe/core/global_widgets/app_button.dart';
import 'package:fintribe/core/global_widgets/app_snackbar.dart';
import 'package:fintribe/core/global_widgets/app_text_field.dart';
import 'package:fintribe/core/router/route_names.dart';
import 'package:fintribe/core/theme/app_colors.dart';
import 'package:fintribe/core/utils/helpers/extensions/context_extensions.dart';
import 'package:fintribe/core/utils/helpers/validators.dart';
import 'package:fintribe/features/auth/data/provider/auth_provider.dart';
import 'package:fintribe/features/auth/ui/login/login_provider.dart';
import 'package:fintribe/features/auth/ui/widgets/auth_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Login screen — email/password with social sign-in options.
final class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _onSubmit() async {
    context.unfocus();
    if (!_formKey.currentState!.validate()) return;
    final form = ref.read(loginFormProvider);
    await ref.read(authProvider.notifier).login(form.email, form.password);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(loginFormProvider);
    final auth = ref.watch(authProvider);
    final isLoading = auth is AsyncLoading;

    // Success navigation is handled by the router's auth-guard redirect;
    // here we only surface failures as a snackbar.
    ref.listen(authProvider, (previous, next) {
      if (next is AsyncError) {
        AppSnackbar.error(context, next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.grey50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UiConstants.spacingLg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: UiConstants.maxContentWidth,
              ),
              child: Column(
                children: [
                  AuthCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: AuthLogo()),
                          const SizedBox(height: UiConstants.spacingLg),
                          Text(
                            'Selamat Datang Kembali',
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: UiConstants.spacingSm),
                          Text(
                            'Masuk untuk melanjutkan ke FinTribe.',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: UiConstants.spacingXl),

                          // ── Email ──────────────────────────────────
                          AppTextField(
                            label: 'Email',
                            hintText: 'nama@email.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.email,
                            onChanged: ref
                                .read(loginFormProvider.notifier)
                                .setEmail,
                          ),
                          const SizedBox(height: UiConstants.spacingLg),

                          // ── Password ───────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Kata Sandi',
                                style: context.textTheme.labelLarge,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    context.pushNamed(RouteNames.forgotPassword),
                                child: Text(
                                  'Lupa Kata Sandi?',
                                  style: context.textTheme.labelLarge?.copyWith(
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: UiConstants.spacingSm),
                          TextFormField(
                            obscureText: form.obscurePassword,
                            textInputAction: TextInputAction.done,
                            validator: Validators.required,
                            onChanged: ref
                                .read(loginFormProvider.notifier)
                                .setPassword,
                            onFieldSubmitted: (_) => _onSubmit(),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  form.obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: ref
                                    .read(loginFormProvider.notifier)
                                    .toggleObscure,
                              ),
                            ),
                          ),
                          const SizedBox(height: UiConstants.spacingLg),

                          AppButton(
                            label: 'Masuk',
                            isLoading: isLoading,
                            onPressed: _onSubmit,
                          ),
                          const SizedBox(height: UiConstants.spacingLg),

                          const AuthOrDivider(label: 'Atau masuk dengan'),
                          const SizedBox(height: UiConstants.spacingLg),

                          SocialButton(
                            label: 'Google',
                            icon: const _GoogleGlyph(),
                            onPressed: () => _comingSoon(context),
                          ),
                          const SizedBox(height: UiConstants.spacingMd),
                          SocialButton(
                            label: 'Apple',
                            icon: const Icon(Icons.apple, size: 22),
                            onPressed: () => _comingSoon(context),
                          ),
                          const SizedBox(height: UiConstants.spacingLg),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Belum punya akun? ',
                                style: context.textTheme.bodyMedium,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    context.pushNamed(RouteNames.register),
                                child: Text(
                                  'Daftar sekarang',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: UiConstants.spacingXl),
                  const AuthFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context) =>
      AppSnackbar.info(context, 'Login sosial segera hadir.');
}

/// A simple multi-color "G" stand-in for the Google logo (no asset needed).
class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF4285F4),
      ),
    );
  }
}
