import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  String? complainerEmail;
  String? complainerNumber;
  String? complaint;
  String? complaintAbout;
  String? complaintId;
  Timestamp? date;

  ComplaintModel({
    this.complainerEmail,
    this.complainerNumber,
    this.complaint,
    this.complaintAbout,
    this.complaintId,
    this.date,
  });

  ComplaintModel.fromJson(Map<String, dynamic> json) {
    complainerEmail = json['complainerEmail'];
    complainerNumber = json['complainerNumber'];
    complaint = json['complaint'];
    complaintAbout = json['complaintAbout'];
    complaintId = json['complaintId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complainerEmail'] = this.complainerEmail;
    data['complainerNumber'] = this.complainerNumber;
    data['complaint'] = this.complaint;
    data['complaintAbout'] = this.complaintAbout;
    data['complaintId'] = this.complaintId;
    data['date'] = this.date;
    return data;
  }
}
