
import 'package:finalproject/screens/forgetpass-screen.dart';
import 'package:finalproject/screens/loginscreen.dart';
import 'package:finalproject/screens/signupscreen.dart';
import 'package:flutter/material.dart';
class TabBarlist extends StatefulWidget {
  const TabBarlist({super.key});

  @override
  State<TabBarlist> createState() => _TabBarlist();
}

class _TabBarlist extends State<TabBarlist> {
  List<String> items = ["Sign Up", "Log In", "Forgot Password"];

  int current = 0;
  List<Widget> pages = [
    const SignUpPage(),
    const LoginPage(),
    const ForgotPasswordPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(top: 40),
                          width: 190,
                          height: 45,
                          decoration: BoxDecoration(
                            color: current == index
                                ? Colors.white70
                                : Colors.white54,
                            borderRadius: current == index
                                ? BorderRadius.circular(15)
                                : BorderRadius.circular(10),
                            border: current == index
                                ? Border.all(color: Colors.orange, width: 3)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              items[index],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: current == index
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: current == index,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2),
              width: double.infinity,
              height: 430,
              child: pages[current],
            ),
          ],
        ),
      ),
    );
  }
}




