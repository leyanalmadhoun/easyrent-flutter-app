import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'customer_home_screen.dart';
import 'office_dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const navy = Color(0xFF12305D);
  static const blue = Color(0xFF1173EA);
  static const grey = Color(0xFF64748B);

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final managerController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isCustomer = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;
  int numberOfCars = 1;
  String countryCode = '+90';
  String subscriptionPlan = 'Monthly';

  @override
  void dispose() {
    nameController.dispose();
    managerController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  String? _email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email address';
    if (!RegExp(r'^[\w\-.]+@[\w\-]+\.[\w\-.]+$').hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _phone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'Please enter your phone number';
    if (phone.length < 7) return 'Please enter a valid phone number';
    return null;
  }

  String? _password(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 8) return 'Use at least 8 characters';
    return null;
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (confirmPasswordController.text != passwordController.text) {
      _showMessage('Passwords do not match.', isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final uid = credential.user!.uid;
      final role = isCustomer ? 'customer' : 'office';
      final data = <String, dynamic>{
        'uid': uid,
        'role': role,
        'email': emailController.text.trim(),
        'phone': '$countryCode${phoneController.text.trim()}',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (isCustomer) {
        data['fullName'] = nameController.text.trim();
      } else {
        data.addAll({
          'officeName': nameController.text.trim(),
          'managerName': managerController.text.trim(),
          'address': addressController.text.trim(),
          'numberOfCars': numberOfCars,
          'subscriptionPlan': subscriptionPlan,
        });
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set(data);
      await credential.user!.updateDisplayName(
        isCustomer ? nameController.text.trim() : managerController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => isCustomer
              ? const CustomerHomeScreen()
              : const OfficeDashboardScreen(),
        ),
        (_) => false,
      );
    } on FirebaseAuthException catch (error) {
      _showMessage(_authMessage(error.code), isError: true);
    } catch (_) {
      _showMessage('Account creation failed. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  String _authMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'operation-not-allowed':
        return 'Email and password sign-up is not enabled.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return 'Account creation failed. Please try again.';
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: isError ? const Color(0xFFDC2626) : const Color(0xFF16A34A), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FD),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navy)),
        ),
        body: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(width: 70, height: 70, padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(21), boxShadow: const [BoxShadow(color: Color(0x181173EA), blurRadius: 20, offset: Offset(0, 8))]), child: Image.asset('assets/images/logo.png', fit: BoxFit.contain)),
                    const SizedBox(height: 17),
                    const Text('Create Your Account', style: TextStyle(color: navy, fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    const Text('Join EasyRent and start your journey today', style: TextStyle(color: grey, fontSize: 14)),
                    const SizedBox(height: 23),
                    _accountTypeSelector(),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.fromLTRB(17, 20, 17, 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE5EBF3)), boxShadow: const [BoxShadow(color: Color(0x09000000), blurRadius: 18, offset: Offset(0, 6))]),
                      child: isCustomer ? _customerForm() : _officeForm(),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _createAccount,
                        style: ElevatedButton.styleFrom(backgroundColor: blue, foregroundColor: Colors.white, disabledBackgroundColor: const Color(0xFF9CC7F9), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                        child: isLoading
                            ? const SizedBox(width: 23, height: 23, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : Text(isCustomer ? 'Create Customer Account' : 'Create Office Account', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Already have an account?', style: TextStyle(color: grey, fontSize: 13)), TextButton(onPressed: () => Navigator.pop(context), child: const Text('Sign In', style: TextStyle(color: blue, fontWeight: FontWeight.w800)))]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _accountTypeSelector() {
    return Container(
      height: 68,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFDCE4EE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: _typeButton('Customer', Icons.person_outline_rounded, isCustomer, () => setState(() => isCustomer = true))),
        Expanded(child: _typeButton('Rental Office', Icons.business_outlined, !isCustomer, () => setState(() => isCustomer = false))),
      ]),
    );
  }

  Widget _typeButton(String title, IconData icon, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? blue : const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(13),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x301173EA),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: selected ? Colors.white : grey, size: 21), const SizedBox(width: 8), Text(title, style: TextStyle(color: selected ? Colors.white : navy, fontSize: 13, fontWeight: FontWeight.w800))]),
      ),
    );
  }

  Widget _customerForm() {
    return Column(children: [
      _field('Full Name', 'Enter your full name', nameController, validator: (v) => _required(v, 'Please enter your full name'), icon: Icons.person_outline_rounded),
      _field('Email Address', 'Enter your email address', emailController, validator: _email, type: TextInputType.emailAddress, icon: Icons.email_outlined),
      _phoneField(),
      _passwordFields(),
    ]);
  }

  Widget _officeForm() {
    return Column(children: [
      _field('Office Name', 'Example: City Center Office', nameController, validator: (v) => _required(v, 'Please enter the office name'), icon: Icons.business_outlined),
      _field('Manager Name', 'Enter the owner or manager name', managerController, validator: (v) => _required(v, 'Please enter the manager name'), icon: Icons.person_outline_rounded),
      _field('Email Address', 'Enter your email address', emailController, validator: _email, type: TextInputType.emailAddress, icon: Icons.email_outlined),
      _phoneField(),
      _field('Office Address', 'Street, city and country', addressController, validator: (v) => _required(v, 'Please enter the office address'), icon: Icons.location_on_outlined, lines: 2),
      _carCounter(),
      _passwordFields(),
      _subscription(),
    ]);
  }

  Widget _phoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Phone Number', style: TextStyle(color: navy, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 92, child: DropdownButtonFormField<String>(initialValue: countryCode, items: const ['+90', '+970', '+972', '+1'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => countryCode = v ?? countryCode), decoration: _decoration('', Icons.flag_outlined))),
          const SizedBox(width: 9),
          Expanded(child: TextFormField(controller: phoneController, validator: _phone, keyboardType: TextInputType.phone, decoration: _decoration('Phone number', Icons.phone_outlined))),
        ]),
      ]),
    );
  }

  Widget _passwordFields() {
    return Column(children: [
      _field('Password', 'At least 8 characters', passwordController, validator: _password, icon: Icons.lock_outline_rounded, obscure: obscurePassword, suffix: IconButton(onPressed: () => setState(() => obscurePassword = !obscurePassword), icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: grey, size: 20))),
      _field('Confirm Password', 'Enter your password again', confirmPasswordController, validator: (v) => _required(v, 'Please confirm your password'), icon: Icons.lock_reset_rounded, obscure: obscureConfirmPassword, suffix: IconButton(onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword), icon: Icon(obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: grey, size: 20))),
    ]);
  }

  Widget _carCounter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Number of Cars', style: TextStyle(color: navy, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7),
        Container(height: 52, decoration: BoxDecoration(color: const Color(0xFFF9FBFE), borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFDCE4EE))), child: Row(children: [IconButton(onPressed: numberOfCars > 1 ? () => setState(() => numberOfCars--) : null, icon: const Icon(Icons.remove_circle_outline_rounded)), Expanded(child: Text('$numberOfCars', textAlign: TextAlign.center, style: const TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.w800))), IconButton(onPressed: () => setState(() => numberOfCars++), icon: const Icon(Icons.add_circle_outline_rounded, color: blue))])),
      ]),
    );
  }

  Widget _subscription() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Subscription Plan', style: TextStyle(color: navy, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(initialValue: subscriptionPlan, items: const ['Monthly', 'Yearly'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => subscriptionPlan = v ?? subscriptionPlan), decoration: _decoration('Choose a plan', Icons.workspace_premium_outlined)),
      ]),
    );
  }

  Widget _field(String label, String hint, TextEditingController controller, {required String? Function(String?) validator, required IconData icon, TextInputType type = TextInputType.text, bool obscure = false, int lines = 1, Widget? suffix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: navy, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7),
        TextFormField(controller: controller, validator: validator, keyboardType: type, obscureText: obscure, maxLines: obscure ? 1 : lines, decoration: _decoration(hint, icon).copyWith(suffixIcon: suffix)),
      ]),
    );
  }

  InputDecoration _decoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9AA7B8), fontSize: 13),
      prefixIcon: Icon(icon, color: grey, size: 20),
      filled: true,
      fillColor: const Color(0xFFF9FBFE),
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFDCE4EE))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: blue, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFDC2626))),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.4)),
    );
  }
}
