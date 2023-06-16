import 'package:cloud_firestore/cloud_firestore.dart';

class AnnounceModel {
  String? announcerEmail;
  String? announcerNumber;
  String? announce;
  String? announceAbout;
  String? announceId;
  Timestamp? date;

  AnnounceModel({
    this.announcerEmail,
    this.announcerNumber,
    this.announce,
    this.announceAbout,
    this.announceId,
    this.date,
  });

  AnnounceModel.fromJson(Map<String, dynamic> json) {
    announcerEmail = json['announcerEmail'];
    announcerNumber = json['announcerNumber'];
    announce = json['announce'];
    announceAbout = json['announceAbout'];
    announceId = json['announceId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['announcerEmail'] = this.announcerEmail;
    data['announcerNumber'] = this.announcerNumber;
    data['announce'] = this.announce;
    data['announceAbout'] = this.announceAbout;
    data['announceId'] = this.announceId;
    data['date'] = this.date;
    return data;
  }
}
