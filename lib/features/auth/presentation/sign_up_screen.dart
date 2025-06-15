import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipes/core/widgets/custom_text_field.dart'; // Your CustomTextField
import 'package:recipes/features/auth/presentation/login_screen.dart';

// Assuming your AuthProvider and AuthState are structured similarly to login
// import 'package:recipes/features/auth/application/auth_provider.dart';
// import 'package:recipes/features/auth/data/auth_state.dart';
// import 'package:recipes/features/auth/logic/auth_helpers.dart';
import 'package:recipes/helpers/app_constants.dart'; // For social provider constants if needed
// import 'package:recipes/features/auth/presentation/login_screen.dart'; // For navigation

// Placeholder for your AppLocalizations if you use them for other texts
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const String routeName = 'SignUpScreen';

  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();

  bool _agreedToTerms = false;
  bool _agreedToNotifications = false;
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  void _signUpWithEmailPassword() {
    FocusScope.of(context).unfocus(); // Hide keyboard
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء الموافقة على شروط الاستخدام أولاً.'), backgroundColor: Colors.red));
      return;
    }
    if (_formKey.currentState!.validate()) {
      // final email = _emailController.text.trim();
      // final password = _passwordController.text.trim();
      // final firstName = _firstNameController.text.trim();
      // final lastName = _lastNameController.text.trim();
      // TODO: Call your auth provider for sign up
      // ref.read(authStateProvider.notifier).signUp(
      //       email: email,
      //       password: password,
      //       firstName: firstName,
      //       lastName: lastName,
      //       agreedToNotifications: _agreedToNotifications,
      //     );
      print('Sign Up with Email/Password');
      print('Email: ${_emailController.text.trim()}');
      print('First Name: ${_firstNameController.text.trim()}');
      print('Last Name: ${_lastNameController.text.trim()}');
      print('Agreed to Notifications: $_agreedToNotifications');
    }
  }

  void _signUpWithGoogle() {
    FocusScope.of(context).unfocus();
    // TODO: Call your auth provider for Google sign up
    // ref.read(authStateProvider.notifier).signUpWithGoogle();
    print('Sign Up with Google');
  }

  void _signUpWithFacebook() {
    FocusScope.of(context).unfocus();
    // TODO: Call your auth provider for Facebook sign up
    // ref.read(authStateProvider.notifier).signUpWithFacebook();
    print('Sign Up with Facebook');
  }

  void _navigateToLogin() {
    // Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    Navigator.of(context).pop(); // Assuming signup is pushed on top of login or a common stack
    print('Navigate to Login Screen');
  }

  void _viewTermsAndConditions() {
    // TODO: Navigate to Terms and Conditions screen or show a dialog
    print('View Terms and Conditions');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم عرض شروط الاستخدام هنا.')));
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authStateProvider); // Your auth state
    // bool isLoading = authState.status == AuthStatus.loading;
    // bool isSocialLoading = authState.status == AuthStatus.socialLoading;
    // String? socialProviderLoading = isSocialLoading ? authState.provider : null;
    // final bool canInteract = !isLoading && !isSocialLoading;

    // Placeholder for loading state, replace with your actual state management
    final bool isLoading = false;
    final bool isSocialLoading = false;
    final String? socialProviderLoading = null;
    final bool canInteract = true;

    // final l10n = AppLocalizations.of(context)!; // For localized strings

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'), // Create New Account
        elevation: 0.5,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomTextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  hintText: 'البريد الالكتروني',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.words,
                  enabled: canInteract,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailFocus);
                  },
                ),
                SizedBox(height: 16.h),
                // --- First Name ---
                CustomTextField(
                  controller: _firstNameController,
                  focusNode: _firstNameFocus,
                  hintText: 'الاسم الأول',
                  // First Name
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  enabled: canInteract,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال الاسم الأول'; // Please enter your first name
                    }
                    if (value.trim().length < 2) {
                      return 'يجب أن يتكون الاسم الأول من حرفين على الأقل';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_lastNameFocus);
                  },
                ),
                SizedBox(height: 16.h),

                // --- Last Name ---
                CustomTextField(
                  controller: _lastNameController,
                  focusNode: _lastNameFocus,
                  hintText: 'اسم العائلة',
                  // Last Name
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  enabled: canInteract,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم العائلة'; // Please enter your last name
                    }
                    if (value.trim().length < 2) {
                      return 'يجب أن يتكون اسم العائلة من حرفين على الأقل';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailFocus);
                  },
                ),
                SizedBox(height: 16.h),

                // --- Password ---
                CustomTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  labelText: 'كلمة المرور',
                  // Password
                  hintText: '********',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _isPasswordObscured,
                  enabled: canInteract,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: theme.hintColor),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    if (value.length < 8) {
                      return 'كلمة المرور يجب أن لا تقل عن 8 أحرف';
                    }
                    // Add more complex password validation if needed (e.g., uppercase, number, symbol)
                    // if (!AuthValidationHelpers.isPasswordCompliant(value)) {
                    //   return l10n.passwordRequirements;
                    // }
                    return null;
                  },
                  onFieldSubmitted: (_) => _signUpWithEmailPassword(),
                ),
                SizedBox(height: 16.h),

                // --- Terms and Conditions Checkbox ---
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: canInteract
                          ? (bool? value) {
                              setState(() {
                                _agreedToTerms = value ?? false;
                              });
                            }
                          : null,
                      activeColor: theme.colorScheme.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                          children: [
                            const TextSpan(text: 'أوافق على '),
                            TextSpan(
                              text: 'شروط الاستخدام',
                              style: TextStyle(color: theme.colorScheme.primary, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()..onTap = _viewTermsAndConditions,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ), // const SizedBox(height: 4.0), // Adjust spacing if needed
                // --- Notifications Checkbox ---
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToNotifications,
                      onChanged: canInteract
                          ? (bool? value) {
                              setState(() {
                                _agreedToNotifications = value ?? false;
                              });
                            }
                          : null,
                      activeColor: theme.colorScheme.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Expanded(child: Text('أوافق على استلام الإشعارات والعروض', style: theme.textTheme.bodyMedium)),
                  ],
                ),
                const SizedBox(height: 24.0),
                // --- Sign Up Button ---
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                  onPressed: canInteract ? _signUpWithEmailPassword : null,
                  child: isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary)),
                        )
                      : const Text('إنشاء الحساب'), // Create Account
                ),
                const SizedBox(height: 20.0),
                // --- OR Separator ---
                Row(
                  children: <Widget>[
                    const Expanded(child: Divider(thickness: 0.8)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'أو', // OR
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    ),
                    const Expanded(child: Divider(thickness: 0.8)),
                  ],
                ),
                const SizedBox(height: 20.0),

                // --- Social Login Buttons ---
                // Google Sign Up Button
                ElevatedButton.icon(
                  icon: socialProviderLoading == AppConstants.googleProvider && isSocialLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onSurface.withOpacity(0.7)),
                          ),
                        )
                      : const Icon(Icons.g_mobiledata_outlined, color: Colors.redAccent), // Placeholder
                  label: const Text('المتابعة باستخدام جوجل'), // Continue with Google
                  onPressed: canInteract ? _signUpWithGoogle : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12.0),

                // Facebook Sign Up Button
                ElevatedButton.icon(
                  icon: socialProviderLoading == AppConstants.faceBookProvider && isSocialLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onSurface.withOpacity(0.7)),
                          ),
                        )
                      : const Icon(Icons.facebook, color: Colors.white), // Ensure you have this asset
                  label: const Text('المتابعة باستخدام فيسبوك'), // Continue with Facebook
                  onPressed: canInteract /* && false */ ? _signUpWithFacebook : null, // Temporarily disable FB if not ready
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 24.0),

                // --- Navigate to Login Screen ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟ ', // Already have an account?
                      style: theme.textTheme.bodyMedium,
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pushReplacementNamed(LoginScreen.routeName),
                      borderRadius: BorderRadius.circular(4.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                        child: Text(
                          'تسجيل الدخول', // Login
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
