class UserProfileModel {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? gender;
  final String? bloodGroup;
  final String? location;
  final DateTime createdAt;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.gender,
    this.bloodGroup,
    this.location,
    required this.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      gender: json['gender'] as String?,
      bloodGroup: json['bloodGroup'] as String?,
      location: json['location'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'location': location,
    };
  }
}
