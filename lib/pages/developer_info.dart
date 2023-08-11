import 'package:flutter/material.dart';

class DevInfoPage extends StatelessWidget {
  const DevInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 205, 191, 245),
      body: SafeArea(
        child: Container(
          decoration:const BoxDecoration(
            gradient: RadialGradient(
              radius: 1.4,
              tileMode: TileMode.clamp,
              colors: [
                Colors.white,
                Color(0xff7C5AF1)
              ], 
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.black87,
                      ))
                ],
              ),
              const Spacer(),
              Image.asset(
                'assets/coffee.png',
                alignment: Alignment.center,
                height: 100,
                width: 200,
              ),
              const Text(
                '© 2023 The Coffee code',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  elevatedButtonWidget('Rate this App', Icons.star, () {}),
                  elevatedButtonWidget('Facebook Page', Icons.facebook, () {}),
                  elevatedButtonWidget('Website', Icons.web, () {}),
                ],
              ),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding elevatedButtonWidget(String text, IconData icon, Function() fun) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: MaterialButton(
        elevation: 10,
        enableFeedback: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        color: Colors.white,
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        onPressed: fun,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Icon(
                icon,
                color: Colors.black87,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
