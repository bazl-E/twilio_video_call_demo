// import 'package:cloud_functions/cloud_functions.dart';

abstract class BackendService {
  // Future<TwilioRoomResponse> completeRoomBySid(TwilioRoomBySidRequest twilioRoomBySidRequest);
  // Future<TwilioRoomResponse> createRoom(TwilioRoomRequest twilioRoomRequest);
  // Future<TwilioRoomTokenResponse> createToken(TwilioRoomTokenRequest twilioRoomTokenRequest);
  // Future<TwilioRoomResponse> getRoomBySid(TwilioRoomBySidRequest twilioRoomBySidRequest);
  // Future<TwilioRoomResponse> getRoomByUniqueName(TwilioRoomByUniqueNameRequest twilioRoomByUniqueNameRequest);
  // Future<TwilioListRoomResponse> listRooms(TwilioListRoomRequest twilioListRoomRequest);
}

class FirebaseFunctionsService implements BackendService {
  FirebaseFunctionsService._();

  // static final instance = FirebaseFunctionsService._();

  // final FirebaseFunctions cf = FirebaseFunctions.instanceFor(region: 'europe-west1');

  // @override
  // Future<TwilioRoomResponse> completeRoomBySid(TwilioRoomBySidRequest twilioRoomBySidRequest) async {
  //   try {
  //     // final response = await cf.httpsCallable('completeRoomBySid').call(twilioRoomBySidRequest.toMap());
  //     return TwilioRoomResponse.fromMap(Map<String, dynamic>.from(response.data));
  //   } on FirebaseFunctionsException catch (e) {
  //     throw PlatformException(
  //       code: e.code,
  //       message: e.message,
  //       details: e.details,
  //     );
  //   }
  // }

  // @override
  // Future<TwilioRoomResponse> createRoom(TwilioRoomRequest twilioRoomRequest) async {
  //   try {
  //     final response = await cf.httpsCallable('createRoom').call(twilioRoomRequest.toMap());
  //     return TwilioRoomResponse.fromMap(Map<String, dynamic>.from(response.data));
  //   }  catch (e) {
  //     throw PlatformException(
  //       code: e.code,
  //       message: e.message,
  //       details: e.details,
  //     );
  //   }
  // }

  // @override
  // Future<TwilioRoomTokenResponse> createToken(TwilioRoomTokenRequest twilioRoomTokenRequest) async {
  //   try {
  //     final response = await cf.httpsCallable('createToken').call(twilioRoomTokenRequest.toMap());
  //     return TwilioRoomTokenResponse.fromMap(Map<String, dynamic>.from(response.data));
  //   } on FirebaseFunctionsException catch (e) {
  //     throw PlatformException(
  //       code: e.code,
  //       message: e.message,
  //       details: e.details,
  //     );
  //   }
  // }

  // @override
  // Future<TwilioRoomResponse> getRoomBySid(TwilioRoomBySidRequest twilioRoomBySidRequest) async {
  //   try {
  //     final response = await cf.httpsCallable('getRoomBySid').call(twilioRoomBySidRequest.toMap());
  //     return TwilioRoomResponse.fromMap(Map<String, dynamic>.from(response.data));
  //   } on FirebaseFunctionsException catch (e) {
  //     throw PlatformException(
  //       code: e.code,
  //       message: e.message,
  //       details: e.details,
  //     );
  //   }
  // }

  // @override
  // Future<TwilioRoomResponse> getRoomByUniqueName(TwilioRoomByUniqueNameRequest twilioRoomByUniqueNameRequest) async {
  //   try {
  //     final response = await cf.httpsCallable('getRoomByUniqueName').call(twilioRoomByUniqueNameRequest.toMap());
  //     return TwilioRoomResponse.fromMap(Map<String, dynamic>.from(response.data));
  //   } on FirebaseFunctionsException catch (e) {
  //     throw PlatformException(
  //       code: e.code,
  //       message: e.message,
  //       details: e.details,
  //     );
  //   }
  // }

  // @override
  // Future<TwilioListRoomResponse> listRooms(TwilioListRoomRequest twilioListRoomRequest) async {
  //   try {
  //     final response = await cf.httpsCallable('listRooms').call(twilioListRoomRequest.toMap());
  //     return TwilioListRoomResponse.fromMap(Map<String, dynamic>.from(response.data));
  //   } on FirebaseFunctionsException catch (e) {
  //     throw PlatformException(
  //       code: e.code,
  //       message: e.message,
  //       details: e.details,
  //     );
  //   }
  // }
}
