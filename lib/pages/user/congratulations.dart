import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistem_managemen_tiket_bus/pages/user/login.dart';
import 'package:sistem_managemen_tiket_bus/utils/constants.dart';

class CongratulationsAccountPage extends StatelessWidget {
  const CongratulationsAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
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
                      "Congratulation!",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Congratulations on creating your BusApp account! 🎉🚌",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 129, 129, 129),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "If you have any questions or need assistance, don't hesitate to reach out. Happy commuting! 😊",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 129, 129, 129),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: borderColor1,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton.filled(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
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
}
