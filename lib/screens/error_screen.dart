import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// hiiii
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:const [
              // SizedBox(
              //   height: 130,
              //   width: 130,
              //   // child: SvgPicture.asset("assets/images/error.svg"),
              // ),
               Text(
                                "OOPS something went wrong!",
                                style: TextStyle(
                                  fontSize: 20,
                                  // fontFamily: "Nunito",
                                  color: Colors.black,
                                ),
                              ),
            ],
          ),
        ),
      
    );
  }
}
