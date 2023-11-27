import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_call/model/room_model.dart';

import '../conference/conference_page.dart';
import '../widgets/button_to_progress.dart';

class JoinRoomForm extends StatefulWidget {
  const JoinRoomForm({
    Key? key,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    return const JoinRoomForm();
  }

  @override
  _JoinRoomFormState createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends State<JoinRoomForm> {
  final TextEditingController _nameController =
      TextEditingController(text: '8sf-nlc5-29u');
  RoomModel roomModel = RoomModel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(roomModel.copyWith(
          name: '8sf-nlc5-29u',
          token:
              'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzU4NmU2OWZhYjZmMWRiYzUxMDNhYzE5NDE1ZjI0NDY2LTE3MDA3MzA1MjgiLCJpc3MiOiJTSzU4NmU2OWZhYjZmMWRiYzUxMDNhYzE5NDE1ZjI0NDY2Iiwic3ViIjoiQUNmMDZmMzI4MTY0OGUyMTcwOTIzODhmNzAwMTE5OGY2OCIsImV4cCI6MTcwMDczNzcyOCwiZ3JhbnRzIjp7ImlkZW50aXR5IjoiYmFzaWwiLCJ2aWRlbyI6eyJyb29tIjoiOHNmLW5sYzUtMjl1In19fQ.KSFDQGVZKSUQn3p5Gq7x5rwqkep0m4kpO5MT5biPJzk',
        )),
      ),
    );
  }

  List<Widget> _buildChildren(RoomModel roomModel) {
    return <Widget>[
      TextField(
        key: const Key('enter-room-name'),
        decoration: InputDecoration(
          labelText: 'Enter room name',
          errorText: roomModel.nameErrorText,
          enabled: !roomModel.isLoading,
        ),
        controller: _nameController,
        onChanged: (val) {
          roomModel.copyWith(name: _nameController.text);
        },
      ),
      const SizedBox(
        height: 16,
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              'Room size:',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          // Expanded(
          //   flex: 3,
          //   child: DropdownButton(
          //       underline: Container(
          //         height: 1,
          //         color: Colors.grey,
          //       ),
          //       isExpanded: true,
          //       items: <TwilioRoomType>[
          //         TwilioRoomType.group,
          //         TwilioRoomType.groupSmall
          //       ].map<DropdownMenuItem<TwilioRoomType>>((TwilioRoomType value) {
          //         return DropdownMenuItem<TwilioRoomType>(
          //           value: value,
          //           child: Text(RoomModel.getTypeText(value)),
          //         );
          //       }).toList(),
          //       value: '',
          //       onChanged: (val) {}),
          // ),
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      _buildButton(roomModel),
      const SizedBox(
        height: 16,
      ),
    ];
  }

  Widget _buildButton(RoomModel roomModel) {
    return ButtonToProgress(
      onLoading: false,
      loadingText: 'Creating the room...',
      progressHeight: 2,
      child: TextButton(
        key: const Key('join-button'),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade300;
          } else {
            return Theme.of(context).appBarTheme.backgroundColor ??
                Theme.of(context).primaryColor;
          }
        })),
        onPressed: () => _submit(),
        child: FittedBox(
          child: Text(
            'JOIN',
            style: TextStyle(
                color: Theme.of(context).appBarTheme.titleTextStyle?.color ??
                    Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    try {
      // final roomModel = await widget.roomBloc.submit();
      await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) =>
              ConferencePage(roomModel: roomModel),
        ),
      );
    } catch (err) {
      log(err.toString());
    }
  }
}
