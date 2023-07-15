import 'package:example/user/create_user.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

import 'package:ethers/signers/wallet.dart' as ether;

void testFetchChats() async {
  initPush();
  const mnemonic =
      'indoor observe crack rocket sea abstract mixed novel angry alone away pass';
  final walletMnemonic = ether.Wallet.fromMnemonic(mnemonic);
  final signer = SignerPrivateKey(
      wallet: walletMnemonic, address: walletMnemonic.address!);

  print('walletMnemonic.address: ${walletMnemonic.address}');
  final user = await getUser(address: walletMnemonic.address!);

  if (user == null) {
    print('Cannot get user');
    return;
  }

  String? pvtkey = null;
  if (user.encryptedPrivateKey != null) {
    pvtkey = await decryptPGPKey(
      encryptedPGPPrivateKey: user.encryptedPrivateKey!,
      wallet: getWallet(signer: signer),
    );
  }

  print('pvtkey: $pvtkey');

  final result = await chats(
    toDecrypt: true,
    pgpPrivateKey: pvtkey!,
    accountAddress: walletMnemonic.address!,
  );

  print(result);
  if (result != null && result.isNotEmpty) {
    print('testFetchChats messageContent: ${result.first.msg?.messageContent}');
  }
}

testAES() {
  final ciphertextOriginal = "U2FsdGVkX18/SWOonW/UfODCpIrRFuOUKITIvRob3iE=";
  final key = "XxJNyUTlCFrrbTG";

  final decryptedMessage = "pong";

  final result = aesDecrypt(cipherText: ciphertextOriginal, secretKey: key);
  print('testAES: result $result, isCorrect: ${result == decryptedMessage}');
}

testSign() async {
  try {
    final result = await signMessageWithPGP(
        message: 'message',
        publicKey: publicKey,
        privateKeyArmored: privateKeyArmored);

    print('testSign: result $result');
  } catch (e) {
    print('testSign: error ${e}');
  }
}

var privateKeyArmored = r'''-----BEGIN PGP PRIVATE KEY BLOCK-----
Version: ObjectivePGP
Comment: https://objectivepgp.com
Charset: UTF-8

xcLYBGSv414BCACbK/w7PAkHPNb+ZSuoSAE4woSTR5DsTxwQonloEC2E7P0RiH3qFQTd3eQg8zL7
VPI22pNH6kcza97LJLTaIBh8IeycdF+LsASGApEMnDMfDJ/AVRpmZTUY2uF5ZXOFOGblJBSMz2uV
X5SqyH8jOSBbNN4/7FfqSaQmbkgWVMgEkQNBRGMvoyTqsuYeIBErf026LMnxHpTOeYLJr+iamKWH
J3Tm1ihukjlJUBn2GIcMjDIBimr3Fc99glQsO1SkUyjr/I/fbn5yw7BeEz9kALBo3Ev7HbfpA6oL
Ih/MzSmZvOSYRJNNrQCn3cNa/7Iyj2zLZItzPC+Q8TGxNIK5+Uv7ABEBAAEACACDE2S9pLj7pCj4
O/3k6O4fRDE5N/rzot/SLWzgusm4v3gGl4XFdnvl7soGC2nFZLw2GezPktcSWMyaTSd4GiSUtxNo
FeWf2c/4Y7KjNE76q29GyJzEYjm4BSzxnwE2R66jYRb62zvFsjejDDpZRqhOYxpaZQrendZLoFzE
gFl1gLjFybcpEMAjXwCWeD6afGBLYTSsjjM7GilmezpuvFLdCyOPSHk6T1dYrtN/5px97nTHdbW0
Q7ViuAnHuDv6LrWQF4+qSrKR48T1s5p9ZdHZIdMVd1fTyylrY2cysomKVwIGcElIbvMDNiuO2pnJ
BpORgTV6y3+SpXO+j5KRGeQBBADH3JMO7ZPIFKla0ZlfmHE1GnCPJ6mp9noXVHZSB72cCWfRBOw+
3m1zsmkqLZy2QKAi3XhguR4XVQ+SM6FVJF+Q3l79gWwDkZ7oP12kHiRrBR3Lt5lOJ8oFIoBI+7Fs
r/823Q2dSlYAEhQ2nyhsCXgmwEHfQacQTX50I1aZgukYIwQAxsHoGD2ViPz1jIgLxoAjIg8Bx00k
kSBxyPnwVdyXQZroxmMKuU9KRrx1rZHCatHKYcI1kUx/9iFuaJgcfx5ipts+ILZgwXrvs0kQr3eU
SKZkB9nQQ4Z262OwjQWrSvw8SieY2VbVsQmcWTbt3+RHrYQVnk1ly6pE1oswG2BKjkkD/iUUlC4w
PwDGzpWEk0GdHSwzDVE6oDBpA4LVKBZX6reCUBmeeuZrBns7CVxQAQzKI5/zB71ABhj+rR8nqoOs
rAkT95tAoSqTMl4Lr1iwcqYsdSy+IEQSkz/a8SLvYetDJ1Uq0xAwcjYWBYu5ErjYvOemY0b+FVpG
DUn6oE1WPmjPLBvNAMLAkQQTAQIAJAUCZK/jXgIbAwQVCAkKBwsJCAcDAgEEFgIBAwIeAQIXgAIZ
AQAhCRCM/tDaqFuGDxYhBEKn7AMo2uzAPBPCxoz+0NqoW4YPztoH/jPvtub1kxYNyiQzGGi/Knqt
yue2EZNBV7MRII0OTM3D+rJF0zwieGfv5Se+MT0/2PAfKax2XuiSB/dz5vX425r1Ye6f3mb1i8mY
UdCGGYdP0Ulf06mUQJyYU/9XlT/fIb9GsrkEe75P08XlmDWumZLFiKRDAjY8g5yShbH0irk73iVl
ohCFF+JQMJFdOCOwT8tV6Z4SJz2Usc9S7tmt/eUypY5xMgxlw5e3xg9xoe3IoqrWCdkoC610raMQ
ThChwEthpwhrIVUV4oXLasJl3e
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
=TaXc
-----END PGP PRIVATE KEY BLOCK-----
''';

var publicKey = r'''-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: ObjectivePGP
Comment: https://objectivepgp.com
Charset: UTF-8

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
/DFymO6NNAd9Q0eEaLng5ndk
=Xfjp
-----END PGP PUBLIC KEY BLOCK-----''';
