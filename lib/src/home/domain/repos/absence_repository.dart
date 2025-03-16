import 'package:attendance_management/core/utils/typedefs.dart'
    show ResultFuture;
import 'package:attendance_management/src/home/domain/entities/absence.dart'
    show Absence;

abstract class AbsenceRepository {
  const AbsenceRepository();

  ResultFuture<List<Absence>> getAbsences();

}
