import 'package:flutter/material.dart';
import 'package:mmc/screens/otp_screen.dart';

class AuthScreenNormal extends StatefulWidget {
  const AuthScreenNormal({Key? key}) : super(key: key);

  @override
  _AuthScreenNormalState createState() => _AuthScreenNormalState();
}

class _AuthScreenNormalState extends State<AuthScreenNormal> {
  final TextEditingController _phoneNoController = TextEditingController();

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
                        'Login',
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
                      controller: _phoneNoController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        // fontFamily: "Nunito",
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Phone number",
                        prefixStyle: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                        ),
                        prefixText: "+91",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                phoneNo: int.parse(_phoneNoController.text),
                              ),
                            ),
                          );
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
                                color: const Color(0xff000000).withOpacity(0.16),
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
