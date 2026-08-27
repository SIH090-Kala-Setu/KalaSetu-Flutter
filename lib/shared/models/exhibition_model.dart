class ExhibitionModel {
  final String id;
  final String name;
  final String location;
  final String status; // Upcoming, Ongoing, Completed, Cancelled
  final String startDate;
  final String endDate;
  final bool isRegistered;

  ExhibitionModel({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.isRegistered = false,
  });

  factory ExhibitionModel.fromJson(Map<String, dynamic> json) {
    return ExhibitionModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      status: json['status']?.toString() ?? json['reg_status']?.toString() ?? 'Upcoming',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      isRegistered: json['reg_status'] != null || json['status'] == 'Approved' || json['status'] == 'Pending',
    );
  }
}

