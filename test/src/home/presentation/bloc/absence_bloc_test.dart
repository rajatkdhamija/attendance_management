import 'package:attendance_management/core/errors/failure.dart';
import 'package:attendance_management/src/home/domain/usecases/get_absences.dart'
    show GetAbsences;
import 'package:attendance_management/src/home/presentation/bloc/absence_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAbsences extends Mock implements GetAbsences {}

void main() {
  late GetAbsences getAbsences;
  late AbsenceBloc bloc;
  final tFailure = FileFailure(
    message: 'Failed to load absences',
    statusCode: 4032,
  );
  setUp(() {
    getAbsences = MockGetAbsences();
    bloc = AbsenceBloc(getAbsences: getAbsences);
  });

  test('initial state should be [AbsenceInitial] ', () async {
    expect(bloc.state, const AbsenceInitial());
  });

  group('getAbsences', () {
    blocTest<AbsenceBloc, AbsenceState>(
      'should emit [AbsencesLoading, AbsencesLoaded] when '
      'getAbsences is called',
      build: () {
        when(() => getAbsences()).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAbsencesEvent()),
      expect: () => const [AbsencesLoading(), AbsencesLoaded(absences: [])],
      verify: (_) {
        verify(() => getAbsences()).called(1);
        verifyNoMoreInteractions(getAbsences);
      },
    );
    blocTest<AbsenceBloc, AbsenceState>(
      'should emit [AbsencesLoading, AbsencesError] when getAbsences '
      'is unsuccessful',
      build: () {
        when(() => getAbsences()).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) {
        bloc.add(const LoadAbsencesEvent());
      },
      expect:
          () => const [
            AbsencesLoading(),
            AbsencesError(message: 'Failed to load absences'),
          ],
      verify: (_) {
        verify(() => getAbsences()).called(1);
        verifyNoMoreInteractions(getAbsences);
      },
    );
  });
}
