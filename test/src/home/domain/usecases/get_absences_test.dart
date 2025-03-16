import 'package:attendance_management/src/home/domain/entities/absence.dart'
    show Absence;
import 'package:attendance_management/src/home/domain/repos/absence_repository.dart'
    show AbsenceRepository;
import 'package:attendance_management/src/home/domain/usecases/get_absences.dart'
    show GetAbsences;
import 'package:dartz/dartz.dart' show Right;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAbsenceRepository extends Mock implements AbsenceRepository {}

void main() {
  late MockAbsenceRepository repo;
  late GetAbsences getAbsencesUseCase;

  setUp(() {
    repo = MockAbsenceRepository();
    getAbsencesUseCase = GetAbsences(repo);
  });

  final tAbsences = <Absence>[];

  test('should return [List<Absence>] from the [AbsenceRepository]', () async {
    when(() => repo.getAbsences()).thenAnswer((_) async => Right(tAbsences));
    final result = await getAbsencesUseCase();

    expect(result, Right<dynamic, List<Absence>>(tAbsences));

    verify(() => repo.getAbsences()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
