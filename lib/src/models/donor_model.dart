/// Donante tal como lo devuelve el back (tabla Donors).
class DonorModel {
  /// Identificador del registro de donante.
  final int id;
  /// UID de Firebase del dueño del registro.
  final String? userId;
  /// Nombre del donante.
  final String name;
  /// Teléfono de contacto.
  final String contactNumber;
  /// Grupo sanguíneo.
  final String bloodGroup;
  /// Ciudad o zona del donante.
  final String location;
  /// Fecha de la última donación, si la hay.
  final DateTime? lastDonationDate;
  /// URL de la foto, si tiene.
  final String? pictureUrl;
  /// Indica si esta disponible para donar.
  final bool isAvailable;
  /// Fecha de registro.
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

  /// Construye el modelo desde el JSON del back.
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

  /// Convierte el modelo a JSON para enviarlo al back.
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
