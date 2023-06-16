class NotificationModel {
  final String alertTime;
  final String location;
  final String tripNumber;
  final String busNumber;
  final String driverNumber;
  final String reportContent;

  NotificationModel({
    required this.alertTime,
    required this.location,
    required this.tripNumber,
    required this.busNumber,
    required this.driverNumber,
    required this.reportContent,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      alertTime: json['alertTime'] ?? '',
      location: json['location'] ?? '',
      tripNumber: json['tripNumber'] ?? '',
      busNumber: json['busNumber'] ?? '',
      driverNumber: json['driverNumber'] ?? '',
      reportContent: json['report-content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alertTime'] = alertTime;
    data['location'] = location;
    data['tripNumber'] = tripNumber;
    data['busNumber'] = busNumber;
    data['driverNumber'] = driverNumber;
    data['report-content'] = reportContent;
    return data;
  }
}
