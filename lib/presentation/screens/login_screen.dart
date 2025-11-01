import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/button_widget.dart';
import '../../core/storage/local_storage.dart';
import 'personnel_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  /// 🔹 Load saved email if available
  Future<void> _loadSavedEmail() async {
    final savedEmail = await LocalStorage.getEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        emailController.text = savedEmail;
        rememberMe = true;
      });
    }
  }

  /// 🔹 Handle Login Button Press
  Future<void> _handleLogin(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter both email and password')));
      return;
    }

    final success = await authProvider.login(email, password, rememberMe);

    if (success) {
      if (rememberMe) {
        await LocalStorage.saveEmail(email);
      } else {
        await LocalStorage.clearEmail();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PersonnelListScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid email or password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back 👋',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                /// 🔹 Email Field
                TextFieldWidget(
                  controller: emailController,
                  hint: 'Email',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                /// 🔹 Password Field
                TextFieldWidget(
                  controller: passwordController,
                  hint: 'Password',
                  obscure: true,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (val) {
                        setState(() => rememberMe = val!);
                      },
                    ),
                    const Text('Remember Me'),
                  ],
                ),
                const SizedBox(height: 24),

                /// 🔹 Login Button
                ButtonWidget(
                  text: authProvider.isLoading ? 'Logging in...' : 'Login',
                  onTap: authProvider.isLoading ? () {} : () => _handleLogin(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
