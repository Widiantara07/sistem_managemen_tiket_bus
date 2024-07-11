import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_managemen_tiket_bus/pages/user/register.dart';
import 'package:sistem_managemen_tiket_bus/providers/auth_provider.dart';
import 'package:sistem_managemen_tiket_bus/providers/theme_provider.dart';
import 'package:sistem_managemen_tiket_bus/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _login() async {
    final provider = Provider.of<UserAuthProvider>(context, listen: false);
    String error = await provider.loginWithEmail(
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;

    if (error.isNotEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(error),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );

      return;
    }

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SafeArea(
                      child: SizedBox(
                        height: 64,
                      ),
                    ),
                    Image.asset('lib/assets/images/logo.png'),
                    const SizedBox(
                      height: 48,
                    ),
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Please enter your email and password to continue",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 129, 129, 129),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CupertinoFormSection(
                      backgroundColor: Colors.transparent,
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? formBGColor
                            : formBGColorLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: themeProvider.isDarkMode
                              ? borderColor1
                              : borderColor1Light,
                          width: 2,
                        ),
                      ),
                      children: [
                        _emailField(),
                        _passwordField(),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // Login text button underlined
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Do not have an account?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 129, 129, 129),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color:
                  themeProvider.isDarkMode ? borderColor1 : borderColor1Light,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton.filled(
                  onPressed: () {
                    _login();
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  CupertinoFormRow _passwordField() {
    return CupertinoFormRow(
      prefix: const Icon(CupertinoIcons.lock_fill),
      child: CupertinoTextField(
        placeholder: "Password",
        autocorrect: false,
        controller: passwordController,
        obscureText: showPassword,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        keyboardType: TextInputType.visiblePassword,
        suffix: CupertinoButton(
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
          padding: EdgeInsets.zero,
          child: Icon(
            showPassword
                ? CupertinoIcons.eye_fill
                : CupertinoIcons.eye_slash_fill,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  CupertinoFormRow _emailField() {
    return CupertinoFormRow(
      prefix: const Icon(CupertinoIcons.at),
      child: CupertinoTextField(
        controller: emailController,
        placeholder: "Email",
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
