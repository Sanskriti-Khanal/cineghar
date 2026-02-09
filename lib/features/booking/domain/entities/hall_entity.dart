import 'package:equatable/equatable.dart';

class HallEntity extends Equatable {
  final String id;
  final String name;

  const HallEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}