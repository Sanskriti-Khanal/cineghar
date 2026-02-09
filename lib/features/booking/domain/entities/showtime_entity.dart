import 'package:equatable/equatable.dart';

class ShowtimeEntity extends Equatable {
  final String id;
  final String time;

  const ShowtimeEntity({
    required this.id,
    required this.time,
  });

  factory ShowtimeEntity.fromJson(Map<String, dynamic> json) {
    final startTime = json['startTime'] as String;
    final dateTime = DateTime.parse(startTime);
    final formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';

    return ShowtimeEntity(
      id: json['_id'] ?? '',
      time: formattedTime,
    );
  }

  @override
  List<Object?> get props => [id, time];
}
