import 'package:attendance_management/core/errors/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileException', () {
    test('should create FileException with correct properties', () {
      const exception = FileException(message: 'File error', statusCode: '404');

      expect(exception.message, 'File error');
      expect(exception.statusCode, '404');
    });

    test('should support value equality', () {
      const exception1 = FileException(message: 'File error', statusCode: '404');
      const exception2 = FileException(message: 'File error', statusCode: '404');

      expect(exception1, equals(exception2)); // Uses Equatable for equality check
    });

    test('should be throwable and catchable as Exception', () {
      try {
        throw const FileException(message: 'Something went wrong', statusCode: '500');
      } catch (e) {
        expect(e, isA<FileException>());
        expect(e.toString(), contains('FileException'));
      }
    });
  });
}
