class ExhibitionModel {
  final String id;
  final String name;
  final String location;
  final String status;
  final String startDate;
  final String endDate;
  final bool isRegistered;
  final String? regStatus; // null | "Pending" | "Approved" | "Rejected"

  ExhibitionModel({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.isRegistered = false,
    this.regStatus,
  });

  factory ExhibitionModel.fromJson(Map<String, dynamic> json) {
    final regStatus = json['reg_status']?.toString();
    final isRegistered = json['is_registered'] == true || regStatus != null;
    return ExhibitionModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Upcoming',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      isRegistered: isRegistered,
      regStatus: regStatus,
    );
  }
}

