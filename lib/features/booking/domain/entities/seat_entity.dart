enum SeatStatus {
  available,
  selected,
  hold,
  booked,
  paid,
}

enum SeatType {
  standard, // $10 - blue
  premium,  // $15 - amber
  vip,      // $25 - purple
}

class SeatEntity {
  final String id;
  final int row;
  final int column;
  final SeatStatus status;
  final SeatType type;
  final DateTime? holdExpiresAt;

  SeatEntity({
    required this.id,
    required this.row,
    required this.column,
    this.status = SeatStatus.available,
    this.type = SeatType.standard,
    this.holdExpiresAt,
  });

  double get price {
    switch (type) {
      case SeatType.standard:
        return 10.0;
      case SeatType.premium:
        return 15.0;
      case SeatType.vip:
        return 25.0;
    }
  }

  SeatEntity copyWith({
    SeatStatus? status,
    SeatType? type,
    DateTime? holdExpiresAt,
  }) {
    return SeatEntity(
      id: id,
      row: row,
      column: column,
      status: status ?? this.status,
      type: type ?? this.type,
      holdExpiresAt: holdExpiresAt ?? this.holdExpiresAt,
    );
  }
}