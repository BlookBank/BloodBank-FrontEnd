import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  /// Determine default backend URL based on runtime platform
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return "http://localhost:5295/api";
    }
    try {
      if (Platform.isAndroid) {
        // Android Emulator uses 10.0.2.2 to access host machine's localhost
        return "http://10.0.2.2:5295/api";
      }
    } catch (_) {}
    return "http://localhost:5295/api";
  }

  String _baseUrl = defaultBaseUrl;

  String get baseUrl => _baseUrl;

  void setBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _headers.remove('Authorization');
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      var uri = Uri.parse("$_baseUrl$endpoint");
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(uri, headers: _headers).timeout(
        const Duration(seconds: 10),
      );

      return _processResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print("API GET Error at $endpoint: $e");
      }
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse("$_baseUrl$endpoint");
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      return _processResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print("API POST Error at $endpoint: $e");
      }
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse("$_baseUrl$endpoint");
      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      return _processResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print("API PUT Error at $endpoint: $e");
      }
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      String errorMessage = "Server error (${response.statusCode})";
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('message')) {
          errorMessage = decoded['message'];
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }
}
