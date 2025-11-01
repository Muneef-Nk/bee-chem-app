import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
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
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final savedEmail = await LocalStorage.getEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        emailController.text = savedEmail;
        rememberMe = true;
      });
    }
  }

  void _showCustomSnackBar(BuildContext context, String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showCustomSnackBar(context, 'Please enter both email and password', color: Colors.blueGrey);
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
      _showCustomSnackBar(context, 'Invalid email or password', color: Colors.red.shade700);
    }
  }

  Widget buildHeader() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset("assets/Frame 18338.png", fit: BoxFit.cover),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Image.asset("assets/Vector.png", width: 60),
                ),
                const SizedBox(height: 8),
                const Text(
                  'BEE CHEM',
                  style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData leadingIcon,
    TextInputAction textInputAction = TextInputAction.next,
    bool isPassword = false,
  }) {
    bool obscureText = isPassword ? !_isPasswordVisible : false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(leadingIcon, color: Colors.grey.shade700, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              textInputAction: textInputAction,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                suffixIcon: isPassword
                    ? GestureDetector(
                        onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey.shade400,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildHeader(),
            const SizedBox(height: 20),
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const Text('Login to your account', style: TextStyle(fontSize: 15, color: Colors.grey)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  _buildInputField(
                    controller: emailController,
                    hint: 'Email address',
                    leadingIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: passwordController,
                    hint: 'Password',
                    leadingIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            activeColor: Colors.amber,
                            value: rememberMe,
                            onChanged: (val) => setState(() => rememberMe = val!),
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Text(
                        'FORGOT PASSWORD?',
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: authProvider.isLoading ? null : () => _handleLogin(context),
                      child: Text(
                        authProvider.isLoading ? 'Logging in...' : 'LOGIN',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.withOpacity(0.4), thickness: 1)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("OR", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.withOpacity(0.4), thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "REGISTER",
                          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
