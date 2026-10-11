import '../../models/blood_request_model.dart';
import 'api_client.dart';

class BloodRequestService {
  final ApiClient _client = ApiClient();

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

  Future<BloodRequestModel?> getRequestById(int id) async {
    final data = await _client.get('/bloodrequests/$id');
    if (data is Map<String, dynamic>) {
      return BloodRequestModel.fromJson(data);
    }
    return null;
  }

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
