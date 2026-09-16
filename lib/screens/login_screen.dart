import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'customer_home_screen.dart';
import 'office_dashboard_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const navy = Color(0xFF12305D);
  static const blue = Color(0xFF1173EA);
  static const grey = Color(0xFF64748B);
  static const background = Color(0xFFF5F8FD);

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email address';
    if (!RegExp(r'^[\w\-.]+@[\w\-]+\.[\w\-.]+$').hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 8) return 'Password must contain at least 8 characters';
    return null;
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDocument.exists) {
        await FirebaseAuth.instance.signOut();
        throw Exception('Account information was not found.');
      }

      final role = userDocument.data()?['role'] as String?;
      if (!mounted) return;

      if (role == 'customer') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
          (_) => false,
        );
      } else if (role == 'office') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const OfficeDashboardScreen()),
          (_) => false,
        );
      } else {
        await FirebaseAuth.instance.signOut();
        throw Exception('This account has an invalid account type.');
      }
    } on FirebaseAuthException catch (error) {
      _showMessage(_authMessage(error.code), isError: true);
    } catch (error) {
      _showMessage(error.toString().replaceFirst('Exception: ', ''), isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = emailController.text.trim();
    if (_validateEmail(email) != null) {
      _showMessage('Enter your email address first.', isError: true);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showMessage('A password reset link was sent to your email.');
    } on FirebaseAuthException catch (error) {
      _showMessage(_authMessage(error.code), isError: true);
    }
  }

  String _authMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return 'Sign in failed. Please try again.';
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: const [
                              BoxShadow(color: Color(0x181173EA), blurRadius: 24, offset: Offset(0, 10)),
                            ],
                          ),
                          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 22),
                        const Text('Welcome Back', style: TextStyle(color: navy, fontSize: 28, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 7),
                        const Text('Sign in to continue your EasyRent journey', textAlign: TextAlign.center, style: TextStyle(color: grey, fontSize: 14, height: 1.4)),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE5EBF3)),
                            boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 6))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('Email Address'),
                              TextFormField(
                                controller: emailController,
                                validator: _validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                decoration: _decoration('Enter your email address', Icons.email_outlined),
                              ),
                              const SizedBox(height: 17),
                              const _FieldLabel('Password'),
                              TextFormField(
                                controller: passwordController,
                                validator: _validatePassword,
                                obscureText: obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _signIn(),
                                decoration: _decoration('Enter your password', Icons.lock_outline_rounded).copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                                    icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: grey, size: 20),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(onPressed: _forgotPassword, child: const Text('Forgot Password?', style: TextStyle(color: blue, fontWeight: FontWeight.w700))),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _signIn,
                                  style: ElevatedButton.styleFrom(backgroundColor: blue, foregroundColor: Colors.white, disabledBackgroundColor: const Color(0xFF9CC7F9), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                                  child: isLoading
                                      ? const SizedBox(width: 23, height: 23, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                      : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?", style: TextStyle(color: grey, fontSize: 13)),
                            TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                              child: const Text('Create Account', style: TextStyle(color: blue, fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9AA7B8), fontSize: 13),
      prefixIcon: Icon(icon, color: grey, size: 21),
      filled: true,
      fillColor: const Color(0xFFF9FBFE),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFDCE4EE))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: blue, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFDC2626))),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.4)),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: _LoginScreenState.navy, fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }
}
