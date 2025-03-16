import 'package:attendance_management/core/errors/exceptions.dart'
    show FileException;
import 'package:attendance_management/core/errors/failure.dart';
import 'package:attendance_management/src/home/data/datasources/absence_local_data_source.dart';
import 'package:attendance_management/src/home/data/repos/absence_repository_implementation.dart';
import 'package:attendance_management/src/home/domain/entities/absence.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAbsenceLocalDataSource extends Mock
    implements AbsenceLocalDataSource {}

void main() {
  late MockAbsenceLocalDataSource localDataSource;
  late AbsenceRepositoryImplementation absenceLocalDataSourceImplementation;
  setUp(() {
    localDataSource = MockAbsenceLocalDataSource();
    absenceLocalDataSourceImplementation = AbsenceRepositoryImplementation(
      localDataSource,
    );
  });

  group('absences', () {
    test('should return a list of [AbsenceModel] when call'
        'to local data source is successful', () async {
      when(
        () => localDataSource.absences(),
      ).thenAnswer((_) async => Future.value([]));
      final result = await absenceLocalDataSourceImplementation.getAbsences();
      expect(result, isA<Right<Failure, List<Absence>>>());
      verify(() => localDataSource.absences()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test('should return a [FileFailure] when call to local data source'
        'is unsuccessful', () async {
      when(() => localDataSource.absences()).thenThrow(
        const FileException(message: 'File not found', statusCode: '404'),
      );
      final result = await absenceLocalDataSourceImplementation.getAbsences();
      expect(
        result,
        equals(
          Left<FileFailure, List<dynamic>>(
            FileFailure(message: 'File not found', statusCode: '404'),
          ),
        ),
      );
      verify(() => localDataSource.absences()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });
  });
}
