import 'package:equatable/equatable.dart';

class BookingSeat extends Equatable {
  final String id; // e.g. "B5"

  const BookingSeat(this.id);

  @override
  List<Object?> get props => [id];
}

class BookingSummaryEntity extends Equatable {
  final String movieId;
  final String movieTitle;
  final String city;
  final String hallId;
  final String hallName;
  final String dateKey; // "today" | "tomorrow"
  final String showtime;
  final String showtimeId;
  final List<BookingSeat> seats;
  final int ticketSubtotal;
  final int snacksSubtotal;
  final int totalBeforeDiscount;

  const BookingSummaryEntity({
    required this.movieId,
    required this.movieTitle,
    required this.city,
    required this.hallId,
    required this.hallName,
    required this.dateKey,
    required this.showtime,
    required this.showtimeId,
    required this.seats,
    required this.ticketSubtotal,
    required this.snacksSubtotal,
    required this.totalBeforeDiscount,
  });

  @override
  List<Object?> get props => [
        movieId,
        movieTitle,
        city,
        hallId,
        hallName,
        dateKey,
        showtime,
        showtimeId,
        seats,
        ticketSubtotal,
        snacksSubtotal,
        totalBeforeDiscount,
      ];
}
