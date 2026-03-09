import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/features/sales/domain/usecases/get_active_offers_usecase.dart';
import 'package:cineghar/features/sales/presentation/state/sales_state.dart';
import 'package:cineghar/features/sales/presentation/providers/sales_providers.dart';

class SalesViewModel extends Notifier<SalesState> {
  late final GetSalesOffersUsecase _getActiveOffersUsecase;

  @override
  SalesState build() {
    _getActiveOffersUsecase = ref.read(getActiveOffersUsecaseProvider);
    // Trigger initial load after the state is initialized
    Future.microtask(() => fetchOffers());
    return const SalesState();
  }

  Future<void> fetchOffers() async {
    try {
      state = state.copyWith(status: SalesStatus.loading);
      final result = await _getActiveOffersUsecase();
      result.fold(
        (failure) {
          state = state.copyWith(
            status: SalesStatus.error,
            errorMessage: failure.message,
          );
        },
        (offers) {
          state = state.copyWith(
            status: SalesStatus.loaded,
            offers: offers,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: SalesStatus.error,
        errorMessage: 'An unexpected error occurred: $e',
      );
    }
  }
}
