import 'package:flutter/material.dart';

class TestingRoom extends StatefulWidget {
  const TestingRoom({super.key});

  @override
  State<TestingRoom> createState() => _TestingRoomState();
}

class _TestingRoomState extends State<TestingRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Room'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
            ),
            const Text("This is a testing pur[ose]"),
            const Image(image: AssetImage('assets/images/1.png')),
            const Image(image: AssetImage('assets/images/2.png')),
            const Image(image: AssetImage('assets/images/3.png')),
            const Image(image: AssetImage('assets/images/4.png')),
            const Image(image: AssetImage('assets/images/5.png')),
            const Center(
              child: Text("THis data is from the database"),
            ),
            const Scaffold(
              body: Center(
                child: Text("This is a scaffold"),
              ),
            )
            // Container(
            // ContinuousRectangleBorder()
          ],
        ),
      ),
    );
  }
}
