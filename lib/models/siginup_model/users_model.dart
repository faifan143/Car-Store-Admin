class UsersModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? userType;
  String? pdfFile;

  UsersModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    required this.image,
    required this.userType,
    required this.pdfFile,
  });
  UsersModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    uId = json['uId'] ?? '';
    image = json['image'] ?? '';
    userType = json['userType'] ?? '';
    pdfFile = json['pdfFile'] ?? '';
  }
  Map<String, dynamic> tomap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
      'pdfFile': pdfFile,
      'userType': userType,
    };
  }
}
