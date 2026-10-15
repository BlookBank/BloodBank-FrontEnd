import '../../models/blood_request_model.dart';
import 'api_client.dart';

/// Acceso a las solicitudes de sangre del back (api/BloodRequests).
class BloodRequestService {
  /// Cliente HTTP compartido (agrega el token de Firebase en cada petición).
  final ApiClient _client = ApiClient();

  /// Lista las solicitudes; [bloodGroup] y [status] filtran en el servidor ("All" significa sin filtro).
  Future<List<BloodRequestModel>> getRequests({String? bloodGroup, String? status}) async {
    final queryParams = <String, String>{};
    if (bloodGroup != null && bloodGroup.isNotEmpty && bloodGroup.toLowerCase() != 'all') {
      queryParams['bloodGroup'] = bloodGroup;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final data = await _client.get('/bloodrequests', queryParams: queryParams.isNotEmpty ? queryParams : null);
    if (data is List) {
      return data.map((item) => BloodRequestModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  /// Devuelve una solicitud por id.
  Future<BloodRequestModel?> getRequestById(int id) async {
    final data = await _client.get('/bloodrequests/$id');
    if (data is Map<String, dynamic>) {
      return BloodRequestModel.fromJson(data);
    }
    return null;
  }

  /// Publica una solicitud nueva. El solicitante lo asigna el back a partir del token.
  Future<BloodRequestModel> createRequest({
    required String patientName,
    required String bloodGroup,
    required int numberOfBags,
    required String contactNumber,
    String? emergencyContact,
    required String caseDescription,
    String? gender,
    required DateTime needBeforeDate,
    required String location,
    String? others,
    String? requesterId,
  }) async {
    // Cuerpo JSON que espera el back (CreateBloodRequestDto).
    final payload = {
      'patientName': patientName,
      'bloodGroup': bloodGroup,
      'numberOfBags': numberOfBags,
      'contactNumber': contactNumber,
      'emergencyContact': emergencyContact,
      'caseDescription': caseDescription,
      'gender': gender,
      'needBeforeDate': needBeforeDate.toIso8601String(),
      'location': location,
      'others': others,
      'requesterId': requesterId,
    };

    final data = await _client.post('/bloodrequests', payload);
    return BloodRequestModel.fromJson(data as Map<String, dynamic>);
  }
}
