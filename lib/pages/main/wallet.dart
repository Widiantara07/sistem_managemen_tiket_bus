import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_managemen_tiket_bus/providers/theme_provider.dart';
import 'package:sistem_managemen_tiket_bus/providers/wallet_provider.dart';
import 'package:sistem_managemen_tiket_bus/utils/constants.dart';

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({super.key});

  @override
  State<MyWalletPage> createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('My Wallet'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 125,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 108, 108, 108),
                    Color.fromARGB(255, 66, 70, 74),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.wallet,
                              color: Colors.blue,
                              size: 32,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'My Wallet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder(
                            future: walletProvider.getWallet(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                  'Rp. 0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                );
                              }

                              if (snapshot.hasData) {
                                return Text(
                                  'Rp. ${snapshot.data}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                );
                              }

                              return const Text(
                                'Rp. 0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        // topup
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: const Text(
                        'Top-Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            // payment history
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    themeProvider.isDarkMode ? formBGColor : formBGColorLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: themeProvider.isDarkMode
                      ? borderColor1
                      : borderColor1Light,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Payment History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(
                      color: borderColor1,
                    ),
                    Text(
                      'No Payment History',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
