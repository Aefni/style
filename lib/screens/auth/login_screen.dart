import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top dark image/gradient header
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    Color(0xFF2D2D44), // Slightly lighter primary for gradient
                    AppColors.primary,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),
          ),

          // Bottom white card
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: AppTextStyles.heading1,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Login to continue shopping',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 28),

                    // Email field
                    Text(
                      'EMAIL',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'user@style.com',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password label row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PASSWORD',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textGrey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child:                     ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() => _isLoading = true);
                                final user = await AuthService.login(
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
                          'LOGIN →',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Register link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                            children: [
                              TextSpan(
                                text: 'Register here',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
}
