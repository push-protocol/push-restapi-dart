import 'package:flutter_test/flutter_test.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart';

void main() async {
  setUp(() {
    initPush();
  });

  group('Api', () {
    test('getAPIBaseUrls', () {
      expect(Api.getAPIBaseUrls(), 'https://backend-staging.epns.io/apis');
      expect(Api.getAPIBaseUrls(ENV.staging),
          'https://backend-staging.epns.io/apis');
      expect(Api.getAPIBaseUrls(ENV.dev), 'https://backend-dev.epns.io/apis');
      expect(Api.getAPIBaseUrls(ENV.prod), 'https://backend.epns.io/apis');
    });

    test('getSocketAPIBaseUrls', () {
      expect(Api.getSocketAPIBaseUrls(), 'https://backend-staging.epns.io');
      expect(Api.getSocketAPIBaseUrls(ENV.staging),
          'https://backend-staging.epns.io');
      expect(Api.getSocketAPIBaseUrls(ENV.dev), 'https://backend-dev.epns.io');
      expect(Api.getSocketAPIBaseUrls(ENV.prod), 'https://backend.epns.io');
    });
  });
}
