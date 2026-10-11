import '../../models/user_profile_model.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _client = ApiClient();

  Future<UserProfileModel?> getUserById(String id) async {
    try {
      final data = await _client.get('/users/$id');
      if (data is Map<String, dynamic>) {
        return UserProfileModel.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  Future<UserProfileModel> syncUser({
    required String id,
    required String email,
    required String name,
    String? phoneNumber,
    String? gender,
    String? bloodGroup,
    String? location,
  }) async {
    final payload = {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'location': location,
    };

    final data = await _client.post('/users/sync', payload);
    return UserProfileModel.fromJson(data as Map<String, dynamic>);
  }

  Future<UserProfileModel?> updateUser({
    required String id,
    String? name,
    String? phoneNumber,
    String? gender,
    String? bloodGroup,
    String? location,
  }) async {
    final payload = <String, dynamic>{};
    if (name != null) payload['name'] = name;
    if (phoneNumber != null) payload['phoneNumber'] = phoneNumber;
    if (gender != null) payload['gender'] = gender;
    if (bloodGroup != null) payload['bloodGroup'] = bloodGroup;
    if (location != null) payload['location'] = location;

    final data = await _client.put('/users/$id', payload);
    if (data is Map<String, dynamic>) {
      return UserProfileModel.fromJson(data);
    }
    return null;
  }
}
