import '../models/parking_spot_model.dart';
import '../services/parking_spot_service.dart';

class ParkingSpotController {
  final ParkingSpotService _service = ParkingSpotService();

  Future<List<ParkingSpot>> getAll() {
    return _service.fetchListParkingSpots();
  }

  Future<ParkingSpot> create(ParkingSpot spot) {
    return _service.createParkingSpot(spot);
  }
}