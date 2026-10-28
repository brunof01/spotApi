class ParkingSpot {
  final String id;
  final String parkingSpotNumber;
  final String licensePlateCar;
  final String brandCar;
  final String modelCar;
  final String colorCar;
  final DateTime registrationDate;
  final String responsibleName;
  final String apartment;
  final String block;

  ParkingSpot(
      this.id,
      this.parkingSpotNumber,
      this.licensePlateCar,
      this.brandCar,
      this.modelCar,
      this.colorCar,
      this.registrationDate,
      this.responsibleName,
      this.apartment,
      this.block,
      );

  ParkingSpot.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        parkingSpotNumber = json['parkingSpotNumber'],
        licensePlateCar = json['licensePlateCar'],
        brandCar = json['brandCar'],
        modelCar = json['modelCar'],
        colorCar = json['colorCar'],
        registrationDate = DateTime.parse(json['registrationDate']),
        responsibleName = json['responsibleName'],
        apartment = json['apartment'],
        block = json['block'];

  // Corpo para POST/PUT: o backend gera id e registrationDate.
  Map<String, dynamic> toJson() => {
    'parkingSpotNumber': parkingSpotNumber,
    'licensePlateCar': licensePlateCar,
    'brandCar': brandCar,
    'modelCar': modelCar,
    'colorCar': colorCar,
    'responsibleName': responsibleName,
    'apartment': apartment,
    'block': block,
  };
}