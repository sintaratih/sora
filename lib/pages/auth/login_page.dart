import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscure = true;
  bool isLoading = false;

  /// LOGIN
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      setState(() => isLoading = true);

      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      _showMsg("Login berhasil!");

      
    } on AuthException catch (e) {
      _showMsg(e.message);
    } catch (e) {
      _showMsg("Terjadi kesalahan");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// SNACKBAR
  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  /// LOGO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "sora",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Selamat datang kembali!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Masuk untuk melanjutkan ke Sora.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// EMAIL
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email"),
                  ),

                  const SizedBox(height: 6),

                  TextFormField(
                    controller: emailController,

                    decoration: InputDecoration(
                      hintText: "Email",

                      filled: true,
                      fillColor: Colors.grey[100],

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Email tidak boleh kosong";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// PASSWORD
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password"),
                  ),

                  const SizedBox(height: 6),

                  TextFormField(
                    controller: passwordController,
                    obscureText: obscure,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                      ),
                    ),

                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Password tidak boleh kosong";
                      }

                      return null;
                    },
                  ),

                  /// BUTTON LOGIN
                  SizedBox(
                    width: double.infinity,

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),

                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFAD33FF),
                            Color(0xFFAD33FF),
                          ],
                        ),
                      ),

                      child: ElevatedButton(
                        onPressed: isLoading ? null : _login,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,

                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),

                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,

                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Masuk",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// REGISTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Text(
                        "Belum punya akun? ",
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },

                        child: const Text(
                          "Daftar di sini",
                          style: TextStyle(
                            color: Colors.deepPurple,
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
}