import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final managerController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  static const navy = Color(0xFF12305D);
  static const blue = Color(0xFF1173EA);
  static const grey = Color(0xFF75849B);
  static const borderColor = Color(0xFFD7DDE6);

  bool isCustomer = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  int numberOfCars = 0;
  String countryCode = '+1';
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

  String? requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? emailValidator(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email address';
    }

    final pattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!pattern.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? phoneValidator(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Please enter your phone number';
    }

    if (phone.length < 7) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must contain at least 8 characters';
    }

    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void changeAccountType(bool customer) {
    FocusScope.of(context).unfocus();

    setState(() {
      isCustomer = customer;
    });

    _formKey.currentState?.reset();
  }

  Future<void> createAccount() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!isCustomer && numberOfCars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the number of cars'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The account will be connected to Firebase later'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: navy,
                      ),
                    ),
                  ),
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Create an Account with ',
                            style: TextStyle(color: navy),
                          ),
                          TextSpan(
                            text: 'Easy',
                            style: TextStyle(color: navy),
                          ),
                          TextSpan(
                            text: 'Rent',
                            style: TextStyle(color: blue),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _accountTypeSelector(),
                  const SizedBox(height: 22),
                  if (isCustomer)
                    _customerForm()
                  else
                    _officeForm(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFF9EC8FA),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : Text(
                        isCustomer
                            ? 'Create Account'
                            : 'Create Office Account',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: grey,
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: blue,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _accountTypeSelector() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE7EBF0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _accountTypeButton(
              title: 'Customer',
              selected: isCustomer,
              onTap: () {
                changeAccountType(true);
              },
            ),
          ),
          Expanded(
            child: _accountTypeButton(
              title: 'Rental Office',
              selected: !isCustomer,
              onTap: () {
                changeAccountType(false);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountTypeButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _customerForm() {
    return Column(
      children: [
        _textField(
          label: 'Full Name',
          hint: 'Enter your full name',
          controller: nameController,
          validator: (value) {
            return requiredValidator(value, 'Please enter your full name');
          },
        ),
        _textField(
          label: 'Email Address',
          hint: 'Enter your email address',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: emailValidator,
        ),
        _phoneField(),
        _passwordField(),
        _confirmPasswordField(),
      ],
    );
  }

  Widget _officeForm() {
    return Column(
      children: [
        _textField(
          label: 'Office Name',
          hint: 'e.g. Main Branch',
          controller: nameController,
          validator: (value) {
            return requiredValidator(value, 'Please enter the office name');
          },
        ),
        _textField(
          label: 'Owner/Manager Name',
          hint: 'e.g. John Doe',
          controller: managerController,
          validator: (value) {
            return requiredValidator(
              value,
              'Please enter the owner or manager name',
            );
          },
        ),
        _textField(
          label: 'Email Address',
          hint: 'Enter your email address',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: emailValidator,
        ),
        _phoneField(),
        _textField(
          label: 'Office Address',
          hint: '123 Main Street, City, Country',
          controller: addressController,
          maxLines: 3,
          validator: (value) {
            return requiredValidator(
              value,
              'Please enter the office address',
            );
          },
        ),
        _carCounter(),
        _passwordField(),
        _confirmPasswordField(),
        _subscriptionSection(),
      ],
    );
  }

  Widget _phoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  'Country Code',
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Phone Number',
                  maxLines: 1,
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: DropdownButtonFormField<String>(
                  initialValue: countryCode,
                  isExpanded: true,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: '+1',
                      child: Text('+1'),
                    ),
                    DropdownMenuItem(
                      value: '+90',
                      child: Text('+90'),
                    ),
                    DropdownMenuItem(
                      value: '+970',
                      child: Text('+970'),
                    ),
                    DropdownMenuItem(
                      value: '+972',
                      child: Text('+972'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        countryCode = value;
                      });
                    }
                  },
                  decoration: _fieldDecoration(''),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: phoneValidator,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                  ),
                  decoration: _fieldDecoration('XXXXXXXXXX'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _carCounter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Number of Cars',
            style: TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        numberOfCars++;
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      color: navy,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$numberOfCars',
                      style: const TextStyle(
                        color: grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: numberOfCars == 0
                        ? null
                        : () {
                      setState(() {
                        numberOfCars--;
                      });
                    },
                    icon: const Icon(Icons.remove),
                    color: navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField() {
    return _textField(
      label: 'Password',
      hint: 'Enter your password',
      controller: passwordController,
      obscureText: obscurePassword,
      validator: passwordValidator,
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            obscurePassword = !obscurePassword;
          });
        },
        icon: Icon(
          obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: grey,
          size: 20,
        ),
      ),
    );
  }

  Widget _confirmPasswordField() {
    return _textField(
      label: 'Confirm Password',
      hint: 'Enter your password again',
      controller: confirmPasswordController,
      obscureText: obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      validator: confirmPasswordValidator,
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            obscureConfirmPassword = !obscureConfirmPassword;
          });
        },
        icon: Icon(
          obscureConfirmPassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: grey,
          size: 20,
        ),
      ),
    );
  }

  Widget _subscriptionSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE4EAF3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subscription Plan',
            style: TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose a plan based on the size of your fleet.',
            style: TextStyle(
              color: grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Plan Type',
            style: TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          DropdownButtonFormField<String>(
            initialValue: subscriptionPlan,
            isExpanded: true,
            style: const TextStyle(
              color: navy,
              fontSize: 14,
            ),
            items: const [
              DropdownMenuItem(
                value: 'Monthly',
                child: Text('Monthly'),
              ),
              DropdownMenuItem(
                value: 'Yearly',
                child: Text('Yearly'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  subscriptionPlan = value;
                });
              }
            },
            decoration: _fieldDecoration('Select a plan'),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            maxLines: obscureText ? 1 : maxLines,
            style: const TextStyle(
              color: navy,
              fontSize: 14,
            ),
            decoration: _fieldDecoration(
              hint,
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(
      String hint, {
        Widget? suffixIcon,
      }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF99A5B5),
        fontSize: 14,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: navy,
          width: 1.3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}