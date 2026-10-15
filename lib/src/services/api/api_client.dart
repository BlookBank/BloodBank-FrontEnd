import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Cliente HTTP para la Web API de ASP.NET.
///
/// En cada petición pide a Firebase el ID token vigente (Firebase lo guarda en
/// el dispositivo y lo renueva solo), así la sesión se mantiene entre reinicios
/// de la app y el backend siempre recibe un token válido.
class ApiClient {
  /// Instancia única (singleton): toda la app comparte la misma URL base y el mismo cliente.
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  /// Tiempo máximo de espera de cada petición antes de fallar.
  static const Duration _timeout = Duration(seconds: 10);

  /// URL por defecto según la plataforma. Para un celular real usa
  /// `ApiClient().setBaseUrl('http://IP-DE-TU-PC:5295/api')`.
  static String get defaultBaseUrl {
    if (kIsWeb) return "http://localhost:5295/api";
    try {
      // El emulador de Android accede al localhost de la PC con 10.0.2.2
      if (Platform.isAndroid) return "http://10.0.2.2:5295/api";
    } catch (_) {}
    return "http://localhost:5295/api";
  }

  /// URL base actual del API; se puede cambiar con [setBaseUrl].
  String _baseUrl = defaultBaseUrl;

  /// URL base actual del API (sin barra final).
  String get baseUrl => _baseUrl;

  /// Cambia la URL base, por ejemplo para probar en un celular real con la IP de la PC.
  void setBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  /// Cabeceras de cada petición: JSON más el token de Firebase del usuario (si hay sesión).
  Future<Map<String, String>> _headers() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      // getIdToken devuelve el token vigente y lo renueva solo si esta por vencer.
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    } catch (_) {
      // Firebase no inicializado o sin sesión: se envía sin token.
    }
    return headers;
  }

  /// Arma la URL completa a partir del endpoint y los parámetros de consulta opcionales.
  Uri _uri(String endpoint, [Map<String, String>? queryParams]) {
    final uri = Uri.parse("$_baseUrl$endpoint");
    return (queryParams != null && queryParams.isNotEmpty)
        ? uri.replace(queryParameters: queryParams)
        : uri;
  }

  /// GET: consulta datos. Devuelve el JSON ya decodificado.
  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) {
    return _send('GET', endpoint,
        () async => http.get(_uri(endpoint, queryParams), headers: await _headers()));
  }

  /// POST: crea un recurso con el cuerpo [data].
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) {
    return _send(
        'POST',
        endpoint,
        () async => http.post(_uri(endpoint),
            headers: await _headers(), body: jsonEncode(data)));
  }

  /// PUT: reemplaza o actualiza un recurso con el cuerpo [data].
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) {
    return _send(
        'PUT',
        endpoint,
        () async => http.put(_uri(endpoint),
            headers: await _headers(), body: jsonEncode(data)));
  }

  /// PATCH: modifica una parte de un recurso.
  Future<dynamic> patch(String endpoint, Object? data) {
    return _send(
        'PATCH',
        endpoint,
        () async => http.patch(_uri(endpoint),
            headers: await _headers(), body: jsonEncode(data)));
  }

  /// DELETE: elimina un recurso.
  Future<dynamic> delete(String endpoint) {
    return _send('DELETE', endpoint,
        () async => http.delete(_uri(endpoint), headers: await _headers()));
  }

  /// Ejecuta la petición con tiempo limite, procesa la respuesta y registra el error en modo debug.
  Future<dynamic> _send(
    String method,
    String endpoint,
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(_timeout);
      return _processResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print("API $method Error at $endpoint: $e");
      }
      rethrow;
    }
  }

  /// Convierte la respuesta HTTP: si es exitosa (2xx) devuelve el JSON; si no, lanza una excepción con el mensaje del back.
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    String errorMessage = "Server error (${response.statusCode})";
    // 401 = token ausente o vencido: se muestra un mensaje claro para el usuario.
    if (response.statusCode == 401) {
      errorMessage = "Your session expired. Please log in again.";
    }
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['message'] is String) {
        errorMessage = decoded['message'] as String;
      }
    } catch (_) {}
    throw Exception(errorMessage);
  }
}
