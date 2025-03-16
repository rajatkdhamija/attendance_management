import 'package:attendance_management/core/errors/exceptions.dart';
import 'package:attendance_management/core/errors/failure.dart'
    show FileFailure;
import 'package:attendance_management/core/utils/typedefs.dart';
import 'package:attendance_management/src/home/data/datasources/absence_local_data_source.dart'
    show AbsenceLocalDataSource;
import 'package:attendance_management/src/home/domain/entities/absence.dart';
import 'package:attendance_management/src/home/domain/repos/absence_repository.dart'
    show AbsenceRepository;
import 'package:dartz/dartz.dart';

class AbsenceRepositoryImplementation implements AbsenceRepository {
  const AbsenceRepositoryImplementation(this._localDataSource);

  final AbsenceLocalDataSource _localDataSource;

  @override
  ResultFuture<List<Absence>> getAbsences() async {
    try {
      final result = await _localDataSource.absences();
      return Right(result);
    } on FileException catch (e) {
      return Left(FileFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
