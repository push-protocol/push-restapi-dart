import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../../push_restapi_dart.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

Future<SpaceDTO?> startSpace({
  String? accountAddress,
  Signer? signer,
  required String spaceId,
  required String livepeerApiKey,
  required Function(ProgressHookType) progressHook,
}) async {
  try {
    accountAddress ??= getCachedWallet()?.address;
    signer ??= getCachedWallet()?.signer;

    final space = await getSpaceById(spaceId: spaceId);

    _livepeerApiKey = livepeerApiKey;

    if (space.status != ChatStatus.PENDING) {
      throw Exception(
          'Unable to start the space as it is not in the pending state');
    }

    final convertedMembers =
        getSpacesMembersList(space.members, space.pendingMembers);
    final convertedAdmins =
        getSpaceAdminsList(space.members, space.pendingMembers);

    ////Create Stream
    final stream = await _createStreamService(spaceName: space.spaceName);

    ///Create room
    final roomId = await _createLivePeerRoom();

    ///add local user as participant
    await _addLivepeerRoomParticipant(
      roomId: roomId,
      participantName: accountAddress ?? signer!.getAddress(),
    );

    ///connect room to stream

    await _startLiveStream(roomId: roomId, streamId: stream.streamId!);

    final group = await push.updateGroup(
      chatId: spaceId,
      groupName: space.spaceName,
      groupImage: space.spaceImage!,
      groupDescription: space.spaceDescription!,
      members: convertedMembers,
      admins: convertedAdmins,
      signer: signer,
      meta: jsonEncode({
        "playbackId": stream.playbackId,
        "roomId": roomId,
      }),
      scheduleAt: space.scheduleAt,
      scheduleEnd: space.scheduleEnd,
      status: ChatStatus.ACTIVE,
      isPublic: space.isPublic,
    );

    if (group != null) {
      return groupDtoToSpaceDto(group);
    } else {
      throw Exception('Error while updating Space : $spaceId');
    }
  } catch (e) {
    print('[Push SDK] - API  - Error - API update -:  $e');
    rethrow;
  }
}

final _livepeerBaseUrl = 'https://livepeer.studio/api';
String _livepeerApiKey = '';

Future<LivepeerStreamDetails> _createStreamService({
  required String spaceName,
}) async {
  final result = await http.post(
    baseUrl: _livepeerBaseUrl,
    path: '/stream',
    headers: {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $_livepeerApiKey',
    },
    data: {
      'name': spaceName,
      'record': true,
    },
  );

  return LivepeerStreamDetails.fromJson(result);
}

Future<String> _createLivePeerRoom() async {
  final result = await http.post(
    baseUrl: _livepeerBaseUrl,
    path: '/room',
    headers: {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $_livepeerApiKey',
    },
    data: {},
  );

  return result['id'];
}

Future<void> _startLiveStream(
    {required String roomId, required String streamId}) async {
  try {
    final result = await http.post(
        baseUrl: _livepeerBaseUrl,
        path: '/room/$roomId/egress',
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer $_livepeerApiKey',
        },
        data: {
          "streamId": streamId
        });
    log('result: $result');
  } catch (error) {
    print(error);
    throw ErrorDescription("Error in starting live stream");
  }
}

Future<LivepeerParticipant> _addLivepeerRoomParticipant({
  required String roomId,
  required String participantName,
}) async {
  final result = await http.post(
    baseUrl: _livepeerBaseUrl,
    path: '/room/$roomId/user',
    headers: {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $_livepeerApiKey',
    },
    data: {
      "name": participantName,
    },
  );

  return LivepeerParticipant.fromJson(result);
}

Future<dynamic> connectToRoomAndPublishVideoAudio(
    {required String url, required String token}) async {
  final roomOptions = RoomOptions(
    adaptiveStream: true,
  );
  final room =
      await LiveKitClient.connect(url, token, roomOptions: roomOptions);
  return room;
}
