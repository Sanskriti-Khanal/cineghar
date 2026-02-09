import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/booking/data/repositories/booking_repository.dart';
import 'package:cineghar/features/booking/domain/entities/booking_entity.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';

class InitiateKhaltiPaymentParams extends Equatable {
  final BookingSummaryEntity booking;
  final String? offerCode;
  final int? loyaltyPointsToRedeem;

  const InitiateKhaltiPaymentParams({
    required this.booking,
    this.offerCode,
    this.loyaltyPointsToRedeem,
  });

  @override
  List<Object?> get props => [booking, offerCode, loyaltyPointsToRedeem];
}



class InitiateKhaltiPaymentUsecase
    implements UsecaseWithParams<Map<String, dynamic>, InitiateKhaltiPaymentParams> {
  final IBookingRepository _repository;

  InitiateKhaltiPaymentUsecase({
    required IBookingRepository repository,
  }) : _repository = repository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    InitiateKhaltiPaymentParams params,
  ) {
    return _repository.initiateKhaltiPayment(
      booking: params.booking,
      offerCode: params.offerCode,
      loyaltyPointsToRedeem: params.loyaltyPointsToRedeem,
    );
  }
}
