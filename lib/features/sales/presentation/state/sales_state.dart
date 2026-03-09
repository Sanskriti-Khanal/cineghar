import 'package:equatable/equatable.dart';
import 'package:cineghar/features/sales/domain/entities/offer_entity.dart';

enum SalesStatus { loading, loaded, error }

class SalesState extends Equatable {
  final SalesStatus status;
  final List<SalesOfferEntity> offers;
  final String? errorMessage;

  const SalesState({
    this.status = SalesStatus.loading,
    this.offers = const [],
    this.errorMessage,
  });

  SalesState copyWith({
    SalesStatus? status,
    List<SalesOfferEntity>? offers,
    String? errorMessage,
  }) {
    return SalesState(
      status: status ?? this.status,
      offers: offers ?? this.offers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, offers, errorMessage];
}

