class CarModel {
  List<dynamic>? imageFiles;
  String? speed;
  String? doors;
  String? seats;
  String? color;
  String? price;
  String? branch;
  String? details;
  String? carId;
  String? modelYear;
  String? tankCapacity;
  String? date;
  String? adminNumber;
  String? priceAfterOffer;
  String? offerExpirationDate;
  String? offerPercentage;
  String? carStatus;

  bool? isUsed;
  bool? isManual;
  bool? isDiesel;
  bool? isOffered;

  CarModel(
      {this.imageFiles,
      this.speed,
      this.priceAfterOffer,
      this.offerExpirationDate,
      this.offerPercentage,
      this.doors,
      this.seats,
      this.color,
      this.price,
      this.branch,
      this.details,
      this.modelYear,
      this.isUsed,
      this.isDiesel,
      this.date,
      this.isManual,
      this.tankCapacity,
      required this.adminNumber,
      required this.carStatus,
      this.isOffered,
      this.carId});

  CarModel.fromJson(Map<String, dynamic> json) {
    if (json['imageFiles'] != null) {
      imageFiles = [];
      json['imageFiles'].forEach((v) {
        imageFiles!.add(v);
      });
    }
    speed = json['speed'];
    doors = json['doors'];
    date = json['createdAt'];
    seats = json['seats'];
    modelYear = json['modelYear'];
    tankCapacity = json['tankCapacity'];
    color = json['color'];
    price = json['price'];
    branch = json['branch'];
    details = json['details'];
    carId = json['carId'];
    isUsed = json['isUsed'];
    isDiesel = json['isDiesel'];
    isManual = json['isManual'];
    isOffered = json['isOffered'];
    adminNumber = json['adminNumber'];
    carStatus = json['carStatus'];
    offerPercentage = json['offerPercentage'];
    priceAfterOffer = json['priceAfterOffer'];
    offerExpirationDate = json['offerExpirationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageFiles'] = this.imageFiles;
    data['speed'] = this.speed;
    data['tankCapacity'] = this.tankCapacity;
    data['doors'] = this.doors;
    data['seats'] = this.seats;
    data['color'] = this.color;
    data['modelYear'] = this.modelYear;
    data['price'] = this.price;
    data['branch'] = this.branch;
    data['details'] = this.details;
    data['carId'] = this.carId;
    data['isUsed'] = this.isUsed;
    data['isDiesel'] = this.isDiesel;
    data['isManual'] = this.isManual;
    data['isOffered'] = this.isOffered;
    data['createdAt'] = this.date;
    data['offerExpirationDate'] = this.offerExpirationDate;
    data['priceAfterOffer'] = this.priceAfterOffer;
    data['offerPercentage'] = this.offerPercentage;
    data['carStatus'] = this.carStatus;
    return data;
  }
}
