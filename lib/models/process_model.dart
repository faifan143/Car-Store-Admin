import 'package:cloud_firestore/cloud_firestore.dart';

class ProcessModel {
  String? car;
  String? carImage;
  String? carId;
  String? clientEmail;
  String? clientNumber;
  String? dealType;
  String? duration;
  String? processId;
  String? receivingDate;
  String? totalCost;
  String? requestStatus;
  String? location;
  Timestamp? requestDate;
  String? deliveryId;

  ProcessModel(
      {this.car,
      this.carImage,
      this.carId,
      this.clientEmail,
      this.clientNumber,
      this.dealType,
      this.duration,
      this.processId,
      this.receivingDate,
      this.requestDate,
      this.requestStatus,
      this.location,
      this.deliveryId,
      this.totalCost});

  ProcessModel.fromJson(Map<String, dynamic> json) {
    car = json['car'];
    carImage = json['carImage'];
    carId = json['carId'];
    clientEmail = json['clientEmail'];
    clientNumber = json['clientNumber'];
    dealType = json['dealType'];
    duration = json['duration'];
    processId = json['processId'];
    receivingDate = json['receivingDate'];
    requestStatus = json['requestStatus'];
    totalCost = json['totalCost'];
    requestDate = json['requestDate'];
    deliveryId = json['deliveryId'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car'] = this.car;
    data['carImage'] = this.carImage;
    data['carId'] = this.carId;
    data['clientEmail'] = this.clientEmail;
    data['clientNumber'] = this.clientNumber;
    data['dealType'] = this.dealType;
    data['duration'] = this.duration;
    data['processId'] = this.processId;
    data['receivingDate'] = this.receivingDate;
    data['totalCost'] = this.totalCost;
    data['requestDate'] = this.requestDate;
    data['requestStatus'] = this.requestStatus;
    data['location'] = this.location;
    data['deliveryId'] = this.deliveryId;
    return data;
  }
}
