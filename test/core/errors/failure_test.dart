import 'package:attendance_management/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('should create Failure with correct properties', () {
      final failure = FileFailure(message: 'File not found', statusCode: 404);

      expect(failure.message, 'File not found');
      expect(failure.statusCode, 404);
      expect(failure.errorMessage, '404 Error: File not found');
    });

    test('should support value equality', () {
      final failure1 = FileFailure(message: 'File error', statusCode: 'E500');
      final failure2 = FileFailure(message: 'File error', statusCode: 'E500');

      expect(failure1, equals(failure2)); // Uses Equatable
    });

    test('should format errorMessage correctly', () {
      final failure1 = FileFailure(message: 'Not Found', statusCode: 404);
      final failure2 = FileFailure(message: 'Server Issue', statusCode: 'E500');

      expect(failure1.errorMessage, '404 Error: Not Found');
      expect(failure2.errorMessage, 'E500 : Server Issue'); // No 'Error' for string status
    });

    test('should throw assertion error for invalid statusCode type', () {
      expect(() => FileFailure(message: 'Invalid Type', statusCode: 3.14),
          throwsA(isA<AssertionError>()));
    });
  });
}
