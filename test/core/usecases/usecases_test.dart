import 'package:attendance_management/core/usecases/usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendance_management/core/utils/typedefs.dart';
import 'package:mocktail/mocktail.dart';


// Mock implementation of UseCaseWithoutParams
class MockUseCaseWithoutParams extends Mock implements UseCaseWithoutParams<String> {
  @override
  ResultFuture<String> call() async {
    return Future.value(Right('Success'));
  }
}

void main() {

  group('UseCaseWithoutParams', () {
    test('should return correct result when called without params', () async {
      final useCase = MockUseCaseWithoutParams();

      final result = await useCase.call();

      expect(result, equals(Right('Success')));
    });
  });
}
