import 'package:fintribe/core/constants/ui_constants.dart';
import 'package:fintribe/core/global_widgets/app_button.dart';
import 'package:fintribe/core/global_widgets/app_snackbar.dart';
import 'package:fintribe/core/theme/app_colors.dart';
import 'package:fintribe/core/utils/helpers/extensions/context_extensions.dart';
import 'package:fintribe/core/utils/helpers/validators.dart';
import 'package:fintribe/features/auth/data/provider/auth_provider.dart';
import 'package:fintribe/features/auth/ui/register/register_provider.dart';
import 'package:fintribe/features/auth/ui/widgets/auth_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Register screen — name/email/password with a strength meter and terms.
final class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _onSubmit() async {
    context.unfocus();
    final form = ref.read(registerFormProvider);
    if (!form.agreeToTerms) {
      AppSnackbar.info(context, 'Setujui Syarat & Ketentuan untuk melanjutkan.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authProvider.notifier)
        .register(name: form.name, email: form.email, password: form.password);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);
    final auth = ref.watch(authProvider);
    final isLoading = auth is AsyncLoading;

    // Success navigation is handled by the router redirect; show errors here.
    ref.listen(authProvider, (previous, next) {
      if (next is AsyncError) {
        AppSnackbar.error(context, next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('FinTribe'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
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
                            'Mulai Perjalanan Finansialmu',
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: UiConstants.spacingSm),
                          Text(
                            'Bergabunglah dengan ribuan perencana cerdas lainnya.',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: UiConstants.spacingXl),

                          _Field(
                            label: 'NAMA LENGKAP',
                            hint: 'Masukkan nama lengkap Anda',
                            icon: Icons.person_outline,
                            textInputAction: TextInputAction.next,
                            validator: (v) => Validators.required(v, 'Nama'),
                            onChanged: notifier.setName,
                          ),
                          const SizedBox(height: UiConstants.spacingLg),

                          _Field(
                            label: 'EMAIL',
                            hint: 'nama@email.com',
                            icon: Icons.mail_outline,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.email,
                            onChanged: notifier.setEmail,
                          ),
                          const SizedBox(height: UiConstants.spacingLg),

                          _Field(
                            label: 'KATA SANDI',
                            hint: 'Minimal 8 karakter',
                            icon: Icons.lock_outline,
                            obscureText: form.obscurePassword,
                            validator: Validators.password,
                            onChanged: notifier.setPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                form.obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: notifier.toggleObscure,
                            ),
                          ),
                          const SizedBox(height: UiConstants.spacingMd),
                          PasswordStrengthBar(strength: form.passwordStrength),
                          const SizedBox(height: UiConstants.spacingMd),

                          _TermsCheckbox(
                            value: form.agreeToTerms,
                            onChanged: notifier.setAgree,
                          ),
                          const SizedBox(height: UiConstants.spacingLg),

                          AppButton(
                            label: 'Daftar Sekarang',
                            icon: const Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.white,
                            ),
                            isLoading: isLoading,
                            onPressed: form.canSubmit ? _onSubmit : null,
                          ),
                          const SizedBox(height: UiConstants.spacingLg),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sudah memiliki akun? ',
                                style: context.textTheme.bodyMedium,
                              ),
                              GestureDetector(
                                onTap: () => context.pop(),
                                child: Text(
                                  'Masuk di sini',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: UiConstants.spacingLg),
                          const _TrustBadges(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: UiConstants.spacingXl),
                  const AuthFooter(showBrand: false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A labelled text field with a leading icon (register-screen style).
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String label;
  final String hint;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: AppColors.grey600,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: UiConstants.spacingSm),
        TextFormField(
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Terms & privacy consent row with tappable (placeholder) links.
class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final link = context.textTheme.bodyMedium?.copyWith(
      color: context.colorScheme.primary,
      fontWeight: FontWeight.w600,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
          ),
        ),
        const SizedBox(width: UiConstants.spacingSm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text.rich(
              TextSpan(
                style: context.textTheme.bodyMedium,
                children: [
                  const TextSpan(text: 'Saya setuju dengan '),
                  TextSpan(text: 'Syarat & Ketentuan', style: link),
                  const TextSpan(text: ' serta '),
                  TextSpan(text: 'Kebijakan Privasi', style: link),
                  const TextSpan(text: ' FinTribe.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// "Secure Data · OJK Registered" trust row.
class _TrustBadges extends StatelessWidget {
  const _TrustBadges();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodySmall?.copyWith(
      color: AppColors.grey500,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, size: 16, color: AppColors.grey500),
        const SizedBox(width: UiConstants.spacingXs),
        Text('Secure Data', style: style),
        const SizedBox(width: UiConstants.spacingMd),
        Text('•', style: style),
        const SizedBox(width: UiConstants.spacingMd),
        const Icon(Icons.verified_outlined, size: 16, color: AppColors.grey500),
        const SizedBox(width: UiConstants.spacingXs),
        Text('OJK Registered', style: style),
      ],
    );
  }
}
