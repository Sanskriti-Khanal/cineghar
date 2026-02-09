import 'package:cineghar/features/booking/data/models/hall_api_model.dart';
import 'package:cineghar/features/booking/data/models/seat_model.dart';
import 'package:cineghar/features/booking/domain/entities/seat_entity.dart';
import 'package:cineghar/features/booking/domain/entities/showtime_entity.dart';

class BookingLocalDatasource {
  // Mock data for cities
  List<String> getCities() {
    return [
      'Kathmandu',
      'Pokhara',
      'Biratnagar',
      'Bhairahawa',
      'Nepalgunj',
      'Dhangadhi',
    ];
  }

  // Mock data for halls
  List<HallApiModel> getHalls(String city) {
    final allHalls = {
      'Kathmandu': [
        HallApiModel(id: 'ktm-royal', name: 'CineGhar Royal'),
        HallApiModel(id: 'ktm-plaza', name: 'CineGhar Plaza'),
        HallApiModel(id: 'ktm-lakeside', name: 'CineGhar Lakeside'),
      ],
      'Pokhara': [
        HallApiModel(id: 'pkr-royal', name: 'CineGhar Pokhara'),
        HallApiModel(id: 'pkr-mall', name: 'CineGhar Mall'),
      ],
      'Biratnagar': [
        HallApiModel(id: 'brt-central', name: 'CineGhar Central'),
      ],
      'Bhairahawa': [
        HallApiModel(id: 'bhw-siddhartha', name: 'CineGhar Siddhartha'),
      ],
      'Nepalgunj': [
        HallApiModel(id: 'ngj-downtown', name: 'CineGhar Downtown'),
      ],
      'Dhangadhi': [
        HallApiModel(id: 'dhi-western', name: 'CineGhar Western'),
      ],
    };

    return allHalls[city] ?? [];
  }

  // Mock data for showtimes
  List<ShowtimeEntity> getShowtimes({
    required String movieId,
    required String hallId,
    required String dateKey,
  }) {
    // Different showtimes based on date
    if (dateKey == 'today') {
      return [
        const ShowtimeEntity(id: 'st-01', time: '10:00 AM'),
        const ShowtimeEntity(id: 'st-02', time: '1:00 PM'),
        const ShowtimeEntity(id: 'st-03', time: '4:00 PM'),
        const ShowtimeEntity(id: 'st-04', time: '7:00 PM'),
        const ShowtimeEntity(id: 'st-05', time: '10:00 PM'),
      ];
    } else if (dateKey == 'tomorrow') {
      return [
        const ShowtimeEntity(id: 'st-06', time: '9:30 AM'),
        const ShowtimeEntity(id: 'st-07', time: '12:30 PM'),
        const ShowtimeEntity(id: 'st-08', time: '3:30 PM'),
        const ShowtimeEntity(id: 'st-09', time: '6:30 PM'),
        const ShowtimeEntity(id: 'st-10', time: '9:30 PM'),
      ];
    }
    
    // Default showtimes
    return [
      const ShowtimeEntity(id: 'st-11', time: '11:00 AM'),
      const ShowtimeEntity(id: 'st-12', time: '2:00 PM'),
      const ShowtimeEntity(id: 'st-13', time: '5:00 PM'),
      const ShowtimeEntity(id: 'st-14', time: '8:00 PM'),
    ];
  }

  // Mock data for seats
  List<List<SeatModel>> getSeats({
    required String hallId,
    required String dateKey,
    required String showtimeId,
  }) {
    // Generate seat layout based on hall size
    final hallSizes = {
      'ktm-royal': 12,
      'ktm-plaza': 15,
      'ktm-lakeside': 10,
      'pkr-royal': 8,
      'pkr-mall': 9,
      'brt-central': 7,
      'bhw-siddhartha': 6,
      'ngj-downtown': 5,
      'dhi-western': 5,
    };

    final rows = hallSizes[hallId] ?? 8;
    final seatsPerRow = 10;
    
    List<List<SeatModel>> seatLayout = [];
    
    for (int row = 0; row < rows; row++) {
      List<SeatModel> rowSeats = [];
      for (int seat = 0; seat < seatsPerRow; seat++) {
        final rowLetter = String.fromCharCode(65 + row); // A, B, C, etc.
        final seatNumber = seat + 1;
        final seatId = '$rowLetter$seatNumber';
        
        // Randomly assign some seats as booked for demonstration
        final isBooked = (row + seat) % 7 == 0; // Some pattern for booked seats
        final isHold = (row + seat) % 11 == 0; // Some pattern for held seats
        
        rowSeats.add(SeatModel(
          id: seatId,
          status: isBooked ? SeatStatus.booked : (isHold ? SeatStatus.hold : SeatStatus.available),
        ));
      }
      seatLayout.add(rowSeats);
    }
    
    return seatLayout;
  }
}