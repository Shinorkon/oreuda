import 'dart:async';

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';
import 'main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  String? _error;
  bool? _apiReachable;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkApi();
  }

  Future<void> _checkApi() async {
    final ok = await ApiService.ping();
    if (mounted) setState(() => _apiReachable = ok);
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (_isLogin) {
        final data = await ApiService.login(
          _usernameController.text.trim(),
          _passwordController.text,
        );
        if (data.containsKey('access_token')) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          }
        } else {
          final detail = data['detail'];
          setState(() => _error = detail is String ? detail : 'Login failed');
        }
      } else {
        final data = await ApiService.register(
          _emailController.text.trim(),
          _usernameController.text.trim(),
          _passwordController.text,
        );
        if (data.containsKey('id')) {
          final loginData = await ApiService.login(
            _usernameController.text.trim(),
            _passwordController.text,
          );
          if (loginData.containsKey('access_token')) {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MainScreen()),
              );
            }
          }
        } else {
          setState(() => _error = data['detail'] ?? 'Registration failed');
        }
      }
    } on TimeoutException {
      setState(() {
        _apiReachable = false;
        _error = 'Timed out reaching ${ApiService.baseUrl}. Press R in the terminal for a full restart.';
      });
    } catch (e) {
      setState(() {
        _apiReachable = false;
        _error = 'Cannot reach API at ${ApiService.baseUrl}\n$e';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                'OREUDA',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'SOLO LEVELING LIFE SYSTEM',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.mutedAsh,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),

              if (_apiReachable != null) ...[
                Text(
                  _apiReachable!
                      ? 'API online · ${ApiService.baseUrl}'
                      : 'API offline · ${ApiService.baseUrl}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: _apiReachable! ? AppColors.successGreen : AppColors.hpCrimson,
                    letterSpacing: 1,
                  ),
                ),
                if (!_apiReachable!) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _checkApi,
                    child: const Text('Retry connection', style: TextStyle(fontSize: 12)),
                  ),
                ],
                const SizedBox(height: 24),
              ] else
                const SizedBox(height: 36),

              // Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.slateSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isLogin = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isLogin ? AppColors.holoCyan.withAlpha(51) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: _isLogin
                                ? Border.all(color: AppColors.holoCyan.withAlpha(128))
                                : null,
                          ),
                          child: Text(
                            'LOGIN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _isLogin ? AppColors.holoCyan : AppColors.mutedAsh,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isLogin = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isLogin ? AppColors.holoCyan.withAlpha(51) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: !_isLogin
                                ? Border.all(color: AppColors.holoCyan.withAlpha(128))
                                : null,
                          ),
                          child: Text(
                            'REGISTER',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: !_isLogin ? AppColors.holoCyan : AppColors.mutedAsh,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              if (!_isLogin)
                _buildTextField(
                  controller: _emailController,
                  label: 'EMAIL',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

              if (!_isLogin) const SizedBox(height: 16),

              _buildTextField(
                controller: _usernameController,
                label: 'USERNAME',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _passwordController,
                label: 'PASSWORD',
                icon: Icons.lock_outline,
                obscureText: true,
              ),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(color: AppColors.hpCrimson, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.black,
                          ),
                        )
                      : Text(_isLogin ? 'AUTHENTICATE' : 'CREATE ACCOUNT'),
                ),
              ),

              const SizedBox(height: 24),

              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin
                      ? 'New hunter? Create account'
                      : 'Already have an account? Login',
                  style: const TextStyle(color: AppColors.systemSilver, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.pureWhite),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.holoCyan, size: 20),
        filled: true,
        fillColor: AppColors.slateSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.holoCyan.withAlpha(77)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.holoCyan.withAlpha(51)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.holoCyan),
        ),
        labelStyle: const TextStyle(color: AppColors.mutedAsh, fontSize: 12),
      ),
    );
  }
}
