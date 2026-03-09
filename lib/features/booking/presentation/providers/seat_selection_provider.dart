import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/seat_entity.dart';

// Provider for managing selected seats
final selectedSeatsProvider = NotifierProvider<SelectedSeatsNotifier, Set<String>>(SelectedSeatsNotifier.new);

class SelectedSeatsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};
  
  void toggleSeat(String seatId) {
    final updatedSelection = Set<String>.from(state);
    if (updatedSelection.contains(seatId)) {
      updatedSelection.remove(seatId);
    } else {
      updatedSelection.add(seatId);
    }
    state = updatedSelection;
  }
  
  void clearSeats() {
    state = <String>{};
  }
}

// Helper to check if a seat is selected
bool isSeatSelected(WidgetRef ref, String seatId) {
  return ref.read(selectedSeatsProvider).contains(seatId);
}

// Helper to toggle seat selection
void toggleSeatSelection(WidgetRef ref, String seatId) {
  ref.read(selectedSeatsProvider.notifier).toggleSeat(seatId);
}
