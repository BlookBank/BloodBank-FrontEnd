class BloodRequestModel {
  final int id;
  final String? requesterId;
  final String patientName;
  final String bloodGroup;
  final int numberOfBags;
  final String contactNumber;
  final String? emergencyContact;
  final String caseDescription;
  final String? gender;
  final DateTime needBeforeDate;
  final String location;
  final String? others;
  final String status;
  final DateTime createdAt;
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

  String get formattedNeedBeforeDate {
    return "${needBeforeDate.day} ${_monthName(needBeforeDate.month)} ${needBeforeDate.year}";
  }

  static String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return "";
  }
}
