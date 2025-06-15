import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipes/core/widgets/custom_text_field.dart';
import 'package:recipes/features/auth/application/auth_provider.dart';
import 'package:recipes/features/auth/data/auth_state.dart'; // YOUR AUTHSTATE PATH
import 'package:recipes/features/auth/logic/auth_helpers.dart';
import 'package:recipes/helpers/app_constants.dart'; // YOUR APP CONSTANTS
import 'dart:io';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginWithEmailPassword() {
    // Hide keyboard
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      ref.read(authStateProvider.notifier).login(email: _emailController.text.trim(), password: _passwordController.text.trim());
    }
  }

  void _loginWithGoogle() {
    FocusScope.of(context).unfocus();
    ref.read(authStateProvider.notifier).loginWithGoogle();
  }

  void _loginWithFacebook() {
    FocusScope.of(context).unfocus();
    ref.read(authStateProvider.notifier).loginWithFacebook();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // Updated loading state checks based on AuthStatus
    bool isLoading = authState.status == AuthStatus.loading;
    bool isSocialLoading = authState.status == AuthStatus.socialLoading;
    String? socialProviderLoading;
    if (isSocialLoading) {
      socialProviderLoading = authState.provider;
    }

    final bool canInteract = !isLoading && !isSocialLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Login Screen')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // --- Logo or App Name (Optional) ---
                // const FlutterLogo(size: 80),
                // const SizedBox(height: 24),
                CustomTextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
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
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder()),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  enabled: canInteract,
                  onFieldSubmitted: canInteract ? (_) => _loginWithEmailPassword() : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.h),
                // --- Forgot Password (Optional) ---
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: canInteract
                        ? () {
                            /* TODO: Navigate to Forgot Password */
                          }
                        : null,
                    child: const Text('?Forgot Password'),
                  ),
                ),
                SizedBox(height: 16.h),
                // --- Error Message Display ---
                // Show error if message exists OR if it's a specific non-initial error status
                if ((authState.message != null && authState.message!.isNotEmpty) ||
                    (authState.status != AuthStatus.initial &&
                        authState.status != AuthStatus.loading &&
                        authState.status != AuthStatus.socialLoading &&
                        authState.status != AuthStatus.authenticated &&
                        authState.status != AuthStatus.loggedOut &&
                        authState.status != AuthStatus.codeResent && // Usually not an error to display here
                        authState.status != AuthStatus.socialSuccess))
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      AuthHelpers.getErrorMessage(authState, _emailController.text.trim()),
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // --- Login Button ---
                ElevatedButton(
                  onPressed: canInteract ? _loginWithEmailPassword : null,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), textStyle: const TextStyle(fontSize: 16)),
                  child:
                      (isLoading) // Only true if authState.status == AuthStatus.loading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                        )
                      : const Text('Login'),
                ),
                SizedBox(height: 20.h),

                // --- Social Login Divider ---
                Row(
                  children: <Widget>[
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 20.h),

                // --- Google Login Button ---
                ElevatedButton.icon(
                  icon: (isSocialLoading && socialProviderLoading == AppConstants.googleProvider)
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                      // TODO: Replace with your actual Google icon asset or an Icon widget
                      : const Icon(Icons.g_mobiledata_outlined, color: Colors.redAccent), // Placeholder
                  // : Image.asset('assets/icons/google_logo.png', height: 20.0, width: 20.0),
                  label: const Text('Sign in with Google'),
                  onPressed: canInteract ? _loginWithGoogle : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    textStyle: TextStyle(fontSize: 15.sp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // --- Facebook Login Button (Show if on mobile platforms) ---
                if (Platform.isAndroid || Platform.isIOS)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ElevatedButton.icon(
                      icon: (isSocialLoading && socialProviderLoading == AppConstants.faceBookProvider)
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          // TODO: Replace with your actual Facebook icon asset or an Icon widget
                          : const Icon(Icons.facebook, color: Colors.white), // Placeholder
                      // : Image.asset('assets/icons/facebook_logo.png', height: 20.0, width: 20.0),
                      label: const Text('Sign in with Facebook'),
                      onPressed: canInteract ? _loginWithFacebook : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        // Facebook Blue
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        textStyle: TextStyle(fontSize: 15.sp),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
