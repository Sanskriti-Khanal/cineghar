import '../../domain/entities/seat_entity.dart';

class SeatModel {
  final String id;
  final SeatStatus status;
  final DateTime? holdExpiresAt;

  const SeatModel({
    required this.id, 
    required this.status,
    this.holdExpiresAt,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'],
      status: SeatStatus.values.firstWhere((e) => e.name == json['status']),
      holdExpiresAt: json['holdExpiresAt'] != null ? DateTime.parse(json['holdExpiresAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'status': status.name,
      if (holdExpiresAt != null) 'holdExpiresAt': holdExpiresAt!.toIso8601String(),
    };
  }

  SeatEntity toEntity() {
    // Assuming id is in format like "A1", "B2", etc.
    final row = id[0];
    final column = int.tryParse(id.substring(1)) ?? 1;
    return SeatEntity(
      id: id,
      row: row.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1,
      column: column,
      status: status,
      type: SeatType.standard, // Default to standard type
      holdExpiresAt: holdExpiresAt,
    );
  }
}