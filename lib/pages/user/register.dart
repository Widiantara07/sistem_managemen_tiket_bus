import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_managemen_tiket_bus/pages/user/congratulations.dart';
import 'package:sistem_managemen_tiket_bus/pages/user/login.dart';
import 'package:sistem_managemen_tiket_bus/providers/auth_provider.dart';
import 'package:sistem_managemen_tiket_bus/providers/theme_provider.dart';
import 'package:sistem_managemen_tiket_bus/utils/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _register() async {
    final provider = Provider.of<UserAuthProvider>(context, listen: false);
    String error = await provider.registerWithEmail(
      usernameController.text,
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

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const CongratulationsAccountPage(),
      ),
    );
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
                      "Get on Board!",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Welcome to Sagatrans! Sign in to track bus schedules and stay informed about service updates. Your journey starts here!",
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
                      key: formKey,
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
                        _name(),
                        _email(),
                        _password(),
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
                          'Already have an account?',
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
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
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
                    _register();
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
            )
          ],
        ),
      ),
    );
  }

  CupertinoFormRow _password() {
    return CupertinoFormRow(
      prefix: const Icon(CupertinoIcons.lock_fill),
      child: CupertinoTextField(
        controller: passwordController,
        placeholder: "Password",
        autocorrect: false,
        obscureText: true,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }

  CupertinoFormRow _email() {
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

  CupertinoFormRow _name() {
    return CupertinoFormRow(
      prefix: const Icon(CupertinoIcons.person_fill),
      child: CupertinoTextField(
        controller: usernameController,
        placeholder: "Your name",
        keyboardType: TextInputType.text,
        autocorrect: false,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
