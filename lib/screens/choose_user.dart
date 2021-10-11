import 'package:flutter/material.dart';
import 'package:mmc/screens/login.dart';
import 'package:mmc/screens/nmc_logn.dart';

class ChooseUser extends StatelessWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AuthScreenNormal()));
            },
            child: const Text("Login"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AuthScreenNmc()));
            },
            child: const Text("NMC Login"),
          ),
        ],
      )),
    );
  }
}
