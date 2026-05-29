import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Dark header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  Color(0xFF2D2D44),
                  AppColors.primary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Create Account',
                            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 28),
                // Title
                Center(
                  child: Text(
                    'Join Style',
                    style: AppTextStyles.heading1.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'CURATING YOUR DIGITAL CLOSET',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white54,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // White card
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Description
                    Text(
                      'Become a part of our exclusive fashion community and discover curated styles tailored just for you.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textGrey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Full Name
                    _buildUnderlineField(
                      controller: _fullNameController,
                      label: 'Full Name',
                    ),
                    const SizedBox(height: 20),

                    // Email
                    _buildUnderlineField(
                      controller: _emailController,
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Phone
                    _buildUnderlineField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // Password
                    _buildUnderlineField(
                      controller: _passwordController,
                      label: 'Password',
                      obscure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textGrey,
                          size: 20,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    _buildUnderlineField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      obscure: _obscureConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textGrey,
                          size: 20,
                        ),
                        onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Create Account button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child:                     ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('Passwords do not match'),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }
                                setState(() => _isLoading = true);
                                final user = await AuthService.signUp(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  context: context,
                                );
                                setState(() => _isLoading = false);
                                if (user != null && context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'CREATE ACCOUNT',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Terms
                    Text(
                      'By clicking Create Account, you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 16),

                    // Login link
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderlineField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
        suffixIcon: suffixIcon,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
