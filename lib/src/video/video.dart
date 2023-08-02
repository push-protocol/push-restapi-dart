import 'package:flutter_webrtc/flutter_webrtc.dart';

class Video {
  final Map<String, Map<String, RTCPeerConnection>> _rtcPeerConnection = {};
  // structure of 
  // {
  //   address: {
  //     peer: RTCPeerConnection,
  //     iceCandidates: RTCIceCandidate
  //   }
  // }

  Future<void> request({
    required String senderAddress,
    required List<String> recipientAddresses,
    required String chatId,
    Object? details,
  }) async {
    print(
        "senderAddress $senderAddress \n recipientAddresses $recipientAddresses \n chatId $chatId details $details");

    for (final recipientAddress in recipientAddresses) {
      try {
        // TODO: Set video call data with status INITIALIZED

        // TODO: Get ice server config from get_ice_server_config
        RTCPeerConnection peer = await createPeerConnection({
          'iceServers':
              // replace the below array with decrypted API result
              [
            {
              'urls': [
                'stun:stun1.l.google.com:19302',
                'stun:stun2.l.google.com:19302'
              ]
            }
          ]
        });

        _rtcPeerConnection[recipientAddress] = { peer: peer, ;

        // add local stream's tracks to RTC connection
        // this.data.local.stream!.getTracks().forEach((track) {
        //   peer.addTrack(track, this.data.local.stream!);
        // });

        // listen for remotePeer mediaTrack event
        peer.onTrack = (event) {
          // save the incoming stream (event.streams[0]) in the state
        };

        // listen for local iceCandidate and add it to the list of IceCandidate
        peer.onIceCandidate =
            (RTCIceCandidate candidate) => rtcIceCadidates.add(candidate);

        // create SDP Offer
        RTCSessionDescription offer = await peer.createOffer();

        // set SDP offer as localDescription for peerConnection
        await peer.setLocalDescription(offer);
      } catch (err) {
        print('error in request $err');
      }
    }
  }

  connect() {
    // when call is accepted by remote peer
    // socket!.on("callAnswered", (data) async {
    //   // set SDP answer as remoteDescription for peerConnection
    //   await _rtcPeerConnection!.setRemoteDescription(
    //     RTCSessionDescription(
    //       data["sdpAnswer"]["sdp"],
    //       data["sdpAnswer"]["type"],
    //     ),
    //   );

    //   // send iceCandidate generated to remote peer over signalling
    //   for (RTCIceCandidate candidate in rtcIceCadidates) {
    //     socket!.emit("IceCandidate", {
    //       "calleeId": widget.calleeId,
    //       "iceCandidate": {
    //         "id": candidate.sdpMid,
    //         "label": candidate.sdpMLineIndex,
    //         "candidate": candidate.candidate
    //       }
    //     });
    //   }
    // });
  }
}
