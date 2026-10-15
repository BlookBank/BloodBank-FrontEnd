import '../../models/donor_model.dart';
import 'api_client.dart';

/// Acceso a los donantes del back (api/Donors).
class DonorService {
  /// Cliente HTTP compartido (agrega el token de Firebase en cada petición).
  final ApiClient _client = ApiClient();

  /// Lista donantes; [bloodGroup] y [isAvailable] filtran en el servidor.
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

  /// Devuelve un donante por id.
  Future<DonorModel?> getDonorById(int id) async {
    final data = await _client.get('/donors/$id');
    if (data is Map<String, dynamic>) {
      return DonorModel.fromJson(data);
    }
    return null;
  }

  /// Registra al usuario como donante (o actualiza su registro si ya lo era).
  Future<DonorModel> registerDonor({
    required String name,
    required String contactNumber,
    required String bloodGroup,
    required String location,
    DateTime? lastDonationDate,
    String? pictureUrl,
    String? userId,
  }) async {
    // Cuerpo JSON que espera el back (CreateDonorDto).
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
