import 'package:flutter/material.dart';

import 'join_room.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twilio Programmable Video'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: _buildOptions(context),
        ),
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _createRoom(context),
          child: const Text('Create Room'),
        ),
        // ElevatedButton(
        //   onPressed: () => _createPreview(context),
        //   child: Text('Create Preview'),
        // ),
      ],
    );
  }

  Future<void> _createRoom(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => JoinRoomPage(),
      ),
    );
  }

  // Future<void> _createPreview(BuildContext context) async {
  //   await Navigator.of(context).push(
  //     MaterialPageRoute<JoinPreviewPage>(
  //       fullscreenDialog: true,
  //       builder: (BuildContext context) => JoinPreviewPage(),
  //     ),
  //   );
  // }
}
