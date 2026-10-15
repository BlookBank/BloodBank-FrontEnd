import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// Documento `users/{uid}` de Firestore (el perfil vive en Firebase).
  factory UserProfileModel.fromFirestore(String id, Map<String, dynamic> data) {
    final created = data['createdAt'];
    return UserProfileModel(
      id: id,
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String?,
      gender: data['gender'] as String?,
      bloodGroup: data['bloodGroup'] as String?,
      location: data['location'] as String?,
      createdAt: created is Timestamp ? created.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'location': location,
    };
  }

  UserProfileModel copyWith({
    String? name,
    String? phoneNumber,
    String? gender,
    String? bloodGroup,
    String? location,
  }) {
    return UserProfileModel(
      id: id,
      email: email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      location: location ?? this.location,
      createdAt: createdAt,
    );
  }
}
