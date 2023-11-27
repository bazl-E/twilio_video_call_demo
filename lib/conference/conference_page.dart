import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

import '../model/conference_room.dart';
import '../model/room_model.dart';
import '../widgets/participant_widget.dart';
import 'conference_button_bar.dart';
import 'draggable_publisher.dart';
import 'noise_box.dart';

class ConferencePage extends StatefulWidget {
  final RoomModel roomModel;

  const ConferencePage({
    Key? key,
    required this.roomModel,
  }) : super(key: key);

  @override
  _ConferencePageState createState() => _ConferencePageState();
}

class _ConferencePageState extends State<ConferencePage> {
  final StreamController<bool> _onButtonBarVisibleStreamController =
      StreamController<bool>.broadcast();
  final StreamController<double> _onButtonBarHeightStreamController =
      StreamController<double>.broadcast();
  ConferenceRoom? _conferenceRoom;
  StreamSubscription? _onConferenceRoomException;
  List<ParticipantWidget> selectedParticipants = [];
  List<ParticipantWidget> totalParticipant = [];

  @override
  void initState() {
    super.initState();
    _lockInPortrait();
    _connectToRoom();
    _wakeLock(true);
  }

  void _connectToRoom() async {
    try {
      final conferenceRoom = ConferenceRoom(
        name: '5rm-lpqa-zbg',
        identity: 'sajan',
        token:
            'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzU4NmU2OWZhYjZmMWRiYzUxMDNhYzE5NDE1ZjI0NDY2LTE3MDEwNzM5MTAiLCJpc3MiOiJTSzU4NmU2OWZhYjZmMWRiYzUxMDNhYzE5NDE1ZjI0NDY2Iiwic3ViIjoiQUNmMDZmMzI4MTY0OGUyMTcwOTIzODhmNzAwMTE5OGY2OCIsImV4cCI6MTcwMTA4MTExMCwiZ3JhbnRzIjp7ImlkZW50aXR5Ijoic2FqbiIsInZpZGVvIjp7InJvb20iOiI1cm0tbHBxYS16YmcifX19.QO2_7wnbFw6Q1n5y3wTx4dArVHGA4XBZBZJEmhC8Jxs',
      );
      await conferenceRoom.connect();

      setState(() {
        _conferenceRoom = conferenceRoom;
        _conferenceRoomUpdated();
        _onConferenceRoomException =
            conferenceRoom.onException.listen((err) async {
          // await _showPlatformAlertDialog(err);
        });
        conferenceRoom.addListener(_conferenceRoomUpdated);
      });
    } catch (err) {
      // log(err.toString());
      // await _showPlatformAlertDialog(err);
      // Navigator.of(context).pop();
    }
  }

  // Future _showPlatformAlertDialog(err) async {
  //   await PlatformAlertDialog(
  //     title: err is PlatformException
  //         ? err.message ?? 'An error occurred'
  //         : 'An error occurred',
  //     content: err is PlatformException
  //         ? (err.details ?? err.toString())
  //         : err.toString(),
  //     defaultActionText: 'OK',
  //   ).show(context);
  // }

  Future<void> _lockInPortrait() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _freePortraitLock();
    _wakeLock(false);
    _disposeStreamsAndSubscriptions();
    _conferenceRoom?.removeListener(_conferenceRoomUpdated);
    super.dispose();
  }

  Future<void> _freePortraitLock() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _disposeStreamsAndSubscriptions() async {
    await _onButtonBarVisibleStreamController.close();
    await _onButtonBarHeightStreamController.close();
    await _onConferenceRoomException?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: buildLayout(),
      ),
    );
  }

  Widget buildLayout() {
    final conferenceRoom = _conferenceRoom;

    return conferenceRoom == null
        ? showProgress()
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: <Widget>[
                  _buildParticipantsGrid(),
                  ConferenceButtonBar(
                    audioEnabled: conferenceRoom.onAudioEnabled,
                    videoEnabled: conferenceRoom.onVideoEnabled,
                    flashState: conferenceRoom.flashStateStream,
                    speakerState: conferenceRoom.speakerStateStream,
                    onAudioEnabled: conferenceRoom.toggleAudioEnabled,
                    onVideoEnabled: conferenceRoom.toggleVideoEnabled,
                    onHangup: _onHangup,
                    onSwitchCamera: conferenceRoom.switchCamera,
                    onToggleSpeaker: conferenceRoom.toggleSpeaker,
                    toggleFlashlight: conferenceRoom.toggleFlashlight,
                    onPersonAdd: _onPersonAdd,
                    onPersonRemove: _onPersonRemove,
                    onHeight: _onHeightBar,
                    onShow: _onShowBar,
                    onHide: _onHideBar,
                  ),
                ],
              );
            },
          );
  }

  Widget showProgress() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(child: CircularProgressIndicator()),
        SizedBox(
          height: 10,
        ),
        Text(
          'Connecting to the room...',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Future<void> _onHangup() async {
    log('onHangup');
    await _conferenceRoom?.disconnect();
    Navigator.of(context).pop();
  }

  void _onPersonAdd() {
    final conferenceRoom = _conferenceRoom;
    if (conferenceRoom == null) return;

    log('onPersonAdd');
    try {
      conferenceRoom.addDummy(
        child: Stack(
          children: <Widget>[
            const Placeholder(),
            Center(
              child: Text(
                (conferenceRoom.participants.length + 1).toString(),
                style: const TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    Shadow(
                      blurRadius: 8.0,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ],
                  fontSize: 80,
                ),
              ),
            ),
          ],
        ),
      );
    } on PlatformException {
      // _showPlatformAlertDialog(err);
    }
  }

  void _onPersonRemove() {
    log('onPersonRemove');
    _conferenceRoom?.removeDummy();
  }

  Widget _buildParticipantsGrid() {
    if (selectedParticipants.length < 2) {
      return _buildNoiseBox();
    }

    if (selectedParticipants.length == 2) {
      return Column(
        children: [
          Expanded(
            child: _buildParticipantItem(
              selectedParticipants[0],
            ),
          ),
          Expanded(
            child: _buildParticipantItem(
              selectedParticipants[1],
            ),
          ),
        ],
      );
    }
    List<Widget> rows = [];

    for (int i = 0; i < selectedParticipants.length; i += 2) {
      List<Widget> rowChildren = [];

      rowChildren.add(
        Expanded(
          child: _buildParticipantItem(
            selectedParticipants[i],
          ),
        ),
      );

      if (i + 1 < selectedParticipants.length) {
        rowChildren.add(
          Expanded(
            child: _buildParticipantItem(
              selectedParticipants[i + 1],
            ),
          ),
        );
      }

      rows.add(
        Expanded(
          child: Row(
            children: rowChildren,
          ),
        ),
      );
    }

    return Column(
      children: rows,
    );
  }

  Widget _buildParticipantItem(ParticipantWidget participant) {
    // For demonstration purposes, using an AspectRatio to fill the available space
    return Container(
        margin: const EdgeInsets.all(2.0),
        // padding: const EdgeInsets.all(16.0),

        child: participant);
  }

  void _buildOverlayLayout(
      BuildContext context, Size size, List<Widget> children) {
    final conferenceRoom = _conferenceRoom;
    if (conferenceRoom == null) return;

    final participants = conferenceRoom.participants;
    if (participants.length == 1) {
      children.add(_buildNoiseBox());
    } else {
      final remoteParticipant = participants.firstWhereOrNull(
          (ParticipantWidget participant) => participant.isRemote);
      if (remoteParticipant != null) {
        children.add(remoteParticipant);
      }
    }

    final localParticipant = participants.firstWhereOrNull(
        (ParticipantWidget participant) => !participant.isRemote);
    if (localParticipant != null) {
      children.add(DraggablePublisher(
        key: const Key('publisher'),
        availableScreenSize: size,
        onButtonBarVisible: _onButtonBarVisibleStreamController.stream,
        onButtonBarHeight: _onButtonBarHeightStreamController.stream,
        child: localParticipant,
      ));
    }
  }

  void _buildLayoutInGrid(
    BuildContext context,
    Size size,
    List<Widget> children, {
    bool removeLocalBeforeChunking = false,
    bool moveLastOfEachRowToNextRow = false,
    int columns = 2,
  }) {
    final conferenceRoom = _conferenceRoom;
    if (conferenceRoom == null) return;

    final participants = conferenceRoom.participants;
    ParticipantWidget? localParticipant;
    if (removeLocalBeforeChunking) {
      localParticipant = participants.firstWhereOrNull(
          (ParticipantWidget participant) => !participant.isRemote);
      if (localParticipant != null) {
        participants.remove(localParticipant);
      }
    }
    final chunkedParticipants = chunk(array: participants, size: columns);
    if (localParticipant != null) {
      chunkedParticipants.last.add(localParticipant);
      participants.add(localParticipant);
    }

    if (moveLastOfEachRowToNextRow) {
      for (var i = 0; i < chunkedParticipants.length - 1; i++) {
        var participant = chunkedParticipants[i].removeLast();
        chunkedParticipants[i + 1].insert(0, participant);
      }
    }

    for (final participantChunk in chunkedParticipants) {
      final rowChildren = <Widget>[];
      for (final participant in participantChunk) {
        rowChildren.add(
          SizedBox(
            width: size.width / participantChunk.length,
            height: size.height / chunkedParticipants.length,
            child: participant,
          ),
        );
      }
      children.add(
        SizedBox(
          height: size.height / chunkedParticipants.length,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowChildren,
          ),
        ),
      );
    }
  }

  NoiseBox _buildNoiseBox() {
    return NoiseBox(
      density: NoiseBoxDensity.xLow,
      backgroundColor: Colors.grey.shade900,
      child: Center(
        child: Container(
          color: Colors.black54,
          width: double.infinity,
          height: 40,
          child: const Center(
            child: Text(
              'Waiting for another participant to connect to the room...',
              key: Key('text-wait'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  List<List<T>> chunk<T>({required List<T> array, required int size}) {
    final result = <List<T>>[];
    if (array.isEmpty || size <= 0) {
      return result;
    }
    var first = 0;
    var last = size;
    final totalLoop = array.length % size == 0
        ? array.length ~/ size
        : array.length ~/ size + 1;
    for (var i = 0; i < totalLoop; i++) {
      if (last > array.length) {
        result.add(array.sublist(first, array.length));
      } else {
        result.add(array.sublist(first, last));
      }
      first = last;
      last = last + size;
    }
    return result;
  }

  List<ParticipantWidget> removeDuplicatesById(
      List<ParticipantWidget> originalList) {
    List<String> encounteredIds = [];
    List<ParticipantWidget> uniqueList = [];

    for (var obj in originalList) {
      if (!encounteredIds.contains(obj.identity)) {
        encounteredIds.add(obj.identity ?? "0");
        uniqueList.add(obj);
      }
    }

    return uniqueList;
  }

  void _onHeightBar(double height) {
    _onButtonBarHeightStreamController.add(height);
  }

  void _onShowBar() {
    setState(() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    });
    _onButtonBarVisibleStreamController.add(true);
  }

  void _onHideBar() {
    setState(() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
    });
    _onButtonBarVisibleStreamController.add(false);
  }

  Future<void> _wakeLock(bool enable) async {
    try {
      return await (enable ? Wakelock.enable() : Wakelock.disable());
    } catch (err) {
      log('Unable to change the Wakelock and set it to $enable');
      log(err.toString());
    }
  }

  void _conferenceRoomUpdated() {
    setState(() {
      // totalParticipant =
      //     removeDuplicatesById(_conferenceRoom?.participants ?? []);
      // if (selectedParticipants.length < 7) {
      selectedParticipants = totalParticipant.sublist(
          0, totalParticipant.length < 7 ? totalParticipant.length : 7);
      // }
    });
  }
}

class ShowAllMembersListScree extends StatefulWidget {
  const ShowAllMembersListScree({
    super.key,
    required this.totalParticipants,
    required this.onSelected,
    required this.selectedParticipant,
    required this.scrollController,
  });

  final List<String> totalParticipants;
  final List<String> selectedParticipant;
  final void Function(int index) onSelected;
  final DraggableScrollableController scrollController;

  @override
  State<ShowAllMembersListScree> createState() =>
      _ShowAllMembersListScreeState();
}

class _ShowAllMembersListScreeState extends State<ShowAllMembersListScree> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: widget.scrollController,
      expand: false,
      maxChildSize: 1,
      // initialChildSize: 1,
      builder: (context, scrollController) {
        return Column(
          children: [
            AppBar(
              title: const Text('All Members'),
              automaticallyImplyLeading: false,
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (widget.selectedParticipant
                      .contains(widget.totalParticipants[index])) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        // Navigator.pop(context);
                        setState(() {
                          widget.onSelected(index);
                        });
                        Navigator.pop(context);
                      },
                      leading: CircleAvatar(
                        child: Text(widget.totalParticipants[index][0]),
                      ),
                      title: Text(widget.totalParticipants[index]),
                      trailing: const Icon(Icons.add),
                    ),
                  );
                },
                itemCount: widget.totalParticipants.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
