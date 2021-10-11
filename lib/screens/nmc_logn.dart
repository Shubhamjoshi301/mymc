import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmc/screens/choose_user.dart';
import 'package:mmc/screens/otp_screen.dart';
import 'package:mmc/screens/showDiscrepancies.dart';

class AuthScreenNmc extends StatefulWidget {
  const AuthScreenNmc({
    Key? key,
  }) : super(key: key);

  @override
  _AuthScreenNmcState createState() => _AuthScreenNmcState();
}

class _AuthScreenNmcState extends State<AuthScreenNmc> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fbfs = FirebaseFirestore.instance;
  Future signIn({String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email as String, password: password as String);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset('assets/images/gdg1.png'),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'NMC Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff262626),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 60,
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      key: UniqueKey(),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        // fontFamily: "Nunito",
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Email",
                        prefixStyle: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff262626),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 60,
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      key: UniqueKey(),
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(
                        // fontFamily: "Nunito",
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Password",
                        prefixStyle: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          signIn(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) {
                            if (value == null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Discrepancies()));
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ChooseUser()));
                            }
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xffFBBC04),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 3),
                                blurRadius: 6,
                                color:
                                    const Color(0xff000000).withOpacity(0.16),
                              ),
                            ],
                          ),
                          child: const Center(
                              child: Icon(
                            Icons.navigate_next_rounded,
                            size: 35,
                          )),
                        ),
                      ),
                    ],
                  ),

                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
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
