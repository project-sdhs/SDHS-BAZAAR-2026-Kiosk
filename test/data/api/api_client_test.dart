import 'dart:convert';

import 'package:bazaar_kiosk/data/api/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('buildUri', () {
    test('baseUrl 과 path 를 슬래시 하나로 합친다', () {
      final client = ApiClient(baseUrl: 'https://api.example.com/');

      expect(
        client.buildUri('health').toString(),
        'https://api.example.com/health',
      );
      expect(
        client.buildUri('/booths', query: {'page': '1'}).toString(),
        'https://api.example.com/booths?page=1',
      );
    });

    test('baseUrl 을 넘기지 않으면 defaultBaseUrl 을 쓴다', () {
      expect(ApiClient().baseUrl, ApiClient.defaultBaseUrl);
    });

    // `flutter test --dart-define=API_BASE_URL=...` 로 돌려도 통과해야 합니다.
    test('defaultBaseUrl 은 API_BASE_URL 이 있으면 그 값, 없으면 localhost:3000', () {
      const hasApiBaseUrl = bool.hasEnvironment('API_BASE_URL');
      const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

      expect(ApiClient.localBaseUrl, 'http://localhost:3000');
      expect(
        ApiClient.defaultBaseUrl,
        hasApiBaseUrl ? apiBaseUrl : ApiClient.localBaseUrl,
      );
    });
  });

  test('GET 성공 응답의 JSON(한글 포함)을 돌려준다', () async {
    final mock = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.toString(), 'https://api.example.com/health');
      return http.Response.bytes(
        utf8.encode(jsonEncode({'status': 'ok', 'name': '메뉴판'})),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final client = ApiClient(
      httpClient: mock,
      baseUrl: 'https://api.example.com',
    );

    final json = await client.get('/health');

    expect(json, {'status': 'ok', 'name': '메뉴판'});
  });

  test('POST 는 body 를 JSON 으로 보낸다', () async {
    final mock = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.headers['Content-Type'], startsWith('application/json'));
      expect(jsonDecode(request.body), {'amount': 1500});
      return http.Response('', 204);
    });
    final client = ApiClient(
      httpClient: mock,
      baseUrl: 'https://api.example.com',
    );

    expect(await client.post('/payments', body: {'amount': 1500}), isNull);
  });

  test('에러 응답이면 서버의 code/message 로 ApiException 을 던진다', () async {
    final mock = MockClient((request) async {
      return http.Response(
        jsonEncode({'code': 'NOT_FOUND', 'message': 'Not Found'}),
        404,
      );
    });
    final client = ApiClient(
      httpClient: mock,
      baseUrl: 'https://api.example.com',
    );

    expect(
      () => client.get('/nope'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 404)
            .having((e) => e.code, 'code', 'NOT_FOUND'),
      ),
    );
  });

  test('에러 응답이 JSON 이 아니어도 ApiException(UNKNOWN)을 던진다', () async {
    final mock = MockClient((request) async {
      return http.Response('<html>Bad Gateway</html>', 502);
    });
    final client = ApiClient(
      httpClient: mock,
      baseUrl: 'https://api.example.com',
    );

    expect(
      () => client.get('/health'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 502)
            .having((e) => e.code, 'code', 'UNKNOWN'),
      ),
    );
  });
}
