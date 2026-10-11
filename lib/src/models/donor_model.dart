class DonorModel {
  final int id;
  final String? userId;
  final String name;
  final String contactNumber;
  final String bloodGroup;
  final String location;
  final DateTime? lastDonationDate;
  final String? pictureUrl;
  final bool isAvailable;
  final DateTime createdAt;

  DonorModel({
    required this.id,
    this.userId,
    required this.name,
    required this.contactNumber,
    required this.bloodGroup,
    required this.location,
    this.lastDonationDate,
    this.pictureUrl,
    required this.isAvailable,
    required this.createdAt,
  });

  factory DonorModel.fromJson(Map<String, dynamic> json) {
    return DonorModel(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as String?,
      name: json['name'] as String? ?? '',
      contactNumber: json['contactNumber'] as String? ?? '',
      bloodGroup: json['bloodGroup'] as String? ?? '',
      location: json['location'] as String? ?? '',
      lastDonationDate: json['lastDonationDate'] != null
          ? DateTime.tryParse(json['lastDonationDate'] as String)
          : null,
      pictureUrl: json['pictureUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'userId': userId,
      'name': name,
      'contactNumber': contactNumber,
      'bloodGroup': bloodGroup,
      'location': location,
      'lastDonationDate': lastDonationDate?.toIso8601String(),
      'pictureUrl': pictureUrl,
    };
  }
}
