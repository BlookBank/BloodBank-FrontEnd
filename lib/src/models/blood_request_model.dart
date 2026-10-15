/// Solicitud de sangre tal como la devuelve el back (tabla BloodRequests).
class BloodRequestModel {
  /// Identificador de la solicitud.
  final int id;
  /// UID de Firebase de quien publicó la solicitud.
  final String? requesterId;
  /// Nombre del paciente.
  final String patientName;
  /// Grupo sanguíneo requerido (A+, O-, ...).
  final String bloodGroup;
  /// Cantidad de bolsas necesarias.
  final int numberOfBags;
  /// Teléfono principal de contacto.
  final String contactNumber;
  /// Teléfono alterno de emergencia.
  final String? emergencyContact;
  /// Motivo o caso clínico.
  final String caseDescription;
  /// Género del paciente.
  final String? gender;
  /// Fecha limite en la que se necesita la sangre.
  final DateTime needBeforeDate;
  /// Ciudad u hospital.
  final String location;
  /// Notas adicionales.
  final String? others;
  /// Estado: Active, Fulfilled o Cancelled.
  final String status;
  /// Fecha de publicación.
  final DateTime createdAt;
  /// Texto relativo calculado por el back ("5 minute ago").
  final String timeAgo;

  BloodRequestModel({
    required this.id,
    this.requesterId,
    required this.patientName,
    required this.bloodGroup,
    required this.numberOfBags,
    required this.contactNumber,
    this.emergencyContact,
    required this.caseDescription,
    this.gender,
    required this.needBeforeDate,
    required this.location,
    this.others,
    required this.status,
    required this.createdAt,
    required this.timeAgo,
  });

  /// Construye el modelo desde el JSON del back; los campos faltantes usan valores por defecto.
  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestModel(
      id: json['id'] as int? ?? 0,
      requesterId: json['requesterId'] as String?,
      patientName: json['patientName'] as String? ?? '',
      bloodGroup: json['bloodGroup'] as String? ?? '',
      numberOfBags: json['numberOfBags'] as int? ?? 1,
      contactNumber: json['contactNumber'] as String? ?? '',
      emergencyContact: json['emergencyContact'] as String?,
      caseDescription: json['caseDescription'] as String? ?? '',
      gender: json['gender'] as String?,
      needBeforeDate: json['needBeforeDate'] != null
          ? DateTime.tryParse(json['needBeforeDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      location: json['location'] as String? ?? '',
      others: json['others'] as String?,
      status: json['status'] as String? ?? 'Active',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      timeAgo: json['timeAgo'] as String? ?? 'Recently',
    );
  }

  /// Convierte el modelo a JSON para enviarlo al back.
  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'requesterId': requesterId,
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
      'status': status,
    };
  }

  /// Fecha limite lista para mostrar, por ejemplo "17 October 2026".
  String get formattedNeedBeforeDate {
    return "${needBeforeDate.day} ${_monthName(needBeforeDate.month)} ${needBeforeDate.year}";
  }

  /// Nombre del mes en ingles para un número del 1 al 12.
  static String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return "";
  }
}
