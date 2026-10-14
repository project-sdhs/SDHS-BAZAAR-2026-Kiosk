import 'dart:convert';

import 'package:http/http.dart' as http;

/// 서버와 통신하는 HTTP 기본 클라이언트.
///
/// 서버 주소는 실행할 때 정합니다 (기본값 [localBaseUrl] = http://localhost:3000).
/// `flutter run -d chrome --dart-define=API_BASE_URL=https://api.example.com`
///
/// 사용 예 (repositories 안에서):
/// ```dart
/// final json = await apiClient.get('/health');
/// ```
class ApiClient {
  ApiClient({http.Client? httpClient, String? baseUrl})
    : _http = httpClient ?? http.Client(),
      baseUrl = baseUrl ?? defaultBaseUrl;

  /// `API_BASE_URL` 을 넘기지 않았을 때 쓰는 로컬 서버 주소.
  static const String localBaseUrl = 'http://localhost:3000';

  /// `--dart-define=API_BASE_URL=...` 로 넘긴 값, 없으면 [localBaseUrl].
  static const String defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: localBaseUrl,
  );

  final http.Client _http;
  final String baseUrl;

  Future<Object?> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<Object?> post(String path, {Object? body}) =>
      _send('POST', path, body: body);

  Future<Object?> patch(String path, {Object? body}) =>
      _send('PATCH', path, body: body);

  Future<Object?> delete(String path) => _send('DELETE', path);

  /// `baseUrl` 과 `path` 를 합쳐 요청 주소를 만듭니다.
  Uri buildUri(String path, {Map<String, String>? query}) {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$base$normalizedPath');
    if (query == null || query.isEmpty) return uri;
    return uri.replace(queryParameters: query);
  }

  /// 앱이 끝날 때 연결을 닫습니다.
  void close() => _http.close();

  Future<Object?> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    final request = http.Request(method, buildUri(path, query: query))
      ..headers['Accept'] = 'application/json';
    if (body != null) {
      request
        ..headers['Content-Type'] = 'application/json; charset=utf-8'
        ..body = jsonEncode(body);
    }

    final response = await http.Response.fromStream(await _http.send(request));
    // 한글이 깨지지 않도록 bytes 를 utf8 로 직접 풉니다.
    final text = utf8.decode(response.bodyBytes);
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    Object? json;
    if (text.isNotEmpty) {
      try {
        json = jsonDecode(text);
      } on FormatException {
        // 에러 응답이 JSON 이 아니면(예: 프록시 HTML) 아래에서 UNKNOWN 으로 처리
        if (isSuccess) rethrow;
      }
    }

    if (isSuccess) return json;
    throw ApiException.fromResponse(response.statusCode, json);
  }
}

/// 서버가 2xx 가 아닌 응답을 줬을 때 던지는 예외.
///
/// 서버 에러 형식: `{ "code": "NOT_FOUND", "message": "..." }`
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.code,
    required this.message,
  });

  factory ApiException.fromResponse(int statusCode, Object? json) {
    final code = json is Map ? json['code'] : null;
    final message = json is Map ? json['message'] : null;
    return ApiException(
      statusCode: statusCode,
      code: code is String ? code : 'UNKNOWN',
      message: message is String ? message : '알 수 없는 오류가 발생했어요.',
    );
  }

  final int statusCode;
  final String code;
  final String message;

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}
