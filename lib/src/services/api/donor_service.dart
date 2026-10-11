import '../../models/donor_model.dart';
import 'api_client.dart';

class DonorService {
  final ApiClient _client = ApiClient();

  Future<List<DonorModel>> getDonors({String? bloodGroup, bool? isAvailable}) async {
    final queryParams = <String, String>{};
    if (bloodGroup != null && bloodGroup.isNotEmpty && bloodGroup.toLowerCase() != 'all') {
      queryParams['bloodGroup'] = bloodGroup;
    }
    if (isAvailable != null) {
      queryParams['isAvailable'] = isAvailable.toString();
    }

    final data = await _client.get('/donors', queryParams: queryParams.isNotEmpty ? queryParams : null);
    if (data is List) {
      return data.map((item) => DonorModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<DonorModel?> getDonorById(int id) async {
    final data = await _client.get('/donors/$id');
    if (data is Map<String, dynamic>) {
      return DonorModel.fromJson(data);
    }
    return null;
  }

  Future<DonorModel> registerDonor({
    required String name,
    required String contactNumber,
    required String bloodGroup,
    required String location,
    DateTime? lastDonationDate,
    String? pictureUrl,
    String? userId,
  }) async {
    final payload = {
      'name': name,
      'contactNumber': contactNumber,
      'bloodGroup': bloodGroup,
      'location': location,
      'lastDonationDate': lastDonationDate?.toIso8601String(),
      'pictureUrl': pictureUrl,
      'userId': userId,
    };

    final data = await _client.post('/donors', payload);
    return DonorModel.fromJson(data as Map<String, dynamic>);
  }
}
