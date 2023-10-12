import 'package:flutter_test/flutter_test.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

void main() async {
  setUp(() {
    initPush(env: ENV.staging);
  });

  test('getUserDID', () async {
    expect(
      await getUserDID(address: '0x8ca107e6845b095599FDc1A937E6f16677a90325'),
      'eip155:0x8ca107e6845b095599FDc1A937E6f16677a90325',
    );
  });

  test('getCAIPAddress', () async {
    expect(
      await getCAIPAddress(
          address: '0x8ca107e6845b095599FDc1A937E6f16677a90325'),
      'eip155:5:0x8ca107e6845b095599FDc1A937E6f16677a90325',
    );
  });
}
