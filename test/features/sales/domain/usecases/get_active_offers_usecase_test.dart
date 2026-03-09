import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/sales/domain/entities/offer_entity.dart';
import 'package:cineghar/features/sales/domain/repositories/sales_repository.dart';
import 'package:cineghar/features/sales/domain/usecases/get_active_offers_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockSalesRepository extends Mock implements ISalesRepository {}

void main() {
  late GetSalesOffersUsecase usecase;
  late MockSalesRepository mockRepository;

  setUp(() {
    mockRepository = MockSalesRepository();
    usecase = GetSalesOffersUsecase(repository: mockRepository);
  });

  const tOffer = SalesOfferEntity(
    id: '1',
    name: 'Test Offer',
    code: 'TEST10',
    type: 'percentage_discount',
    discountPercent: 10,
  );

  test('should return list of offers when repository succeeds', () async {
    // Arrange
    when(() => mockRepository.getActiveOffers())
        .thenAnswer((_) async => const Right([tOffer]));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Right([tOffer]));
    verify(() => mockRepository.getActiveOffers()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    const failure = ApiFailure(message: 'Server error');
    when(() => mockRepository.getActiveOffers())
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Left(failure));
    verify(() => mockRepository.getActiveOffers()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
