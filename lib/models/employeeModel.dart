class EmployeeModel {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? uId;
  String? image;
  String? userType;
  String? pdfFile;
  bool? isAvailable;
  String? joiningDate;
  String? assignedProcessId;
  String? assignedProcessLocation;
  String? daysOfWork;
  List<dynamic>? attendanceSchedule;

  EmployeeModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.uId,
    required this.image,
    required this.userType,
    required this.pdfFile,
    required this.isAvailable,
    required this.joiningDate,
    required this.assignedProcessId,
    required this.assignedProcessLocation,
    required this.attendanceSchedule,
    required this.daysOfWork,
  });

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    phone = json['phone'] ?? '';
    uId = json['uId'] ?? '';
    image = json['image'] ?? '';
    userType = json['userType'] ?? '';
    pdfFile = json['pdfFile'] ?? '';
    isAvailable = json['isAvailable'] ?? '';
    joiningDate = json['joiningDate'] ?? '';
    assignedProcessId = json['assignedProcessId'] ?? '';
    assignedProcessLocation = json['assignedProcessLocation'] ?? '';
    attendanceSchedule = json['attendanceSchedule'] ?? '';
    daysOfWork = json['daysOfWork'] ?? '';
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'uId': uId,
      'image': image,
      'pdfFile': pdfFile,
      'isAvailable': isAvailable,
      'joiningDate': joiningDate,
      'assignedProcessId': assignedProcessId,
      'assignedProcessLocation': assignedProcessLocation,
      'attendanceSchedule': attendanceSchedule,
      'daysOfWork': daysOfWork,
      'userType': userType
    };
  }
}
