import 'package:attendance_management/core/errors/failure.dart' show Failure;
import 'package:attendance_management/core/usecases/usecases.dart';
import 'package:attendance_management/src/home/domain/entities/absence.dart'
    show Absence;
import 'package:attendance_management/src/home/domain/repos/absence_repository.dart'
    show AbsenceRepository;
import 'package:dartz/dartz.dart' show Either;

class GetAbsences extends UseCaseWithoutParams<List<Absence>> {
  GetAbsences(this._repo);

  final AbsenceRepository _repo;

  @override
  Future<Either<Failure, List<Absence>>> call() => _repo.getAbsences();
}
