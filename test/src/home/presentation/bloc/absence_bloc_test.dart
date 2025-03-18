import 'package:attendance_management/core/errors/failure.dart';
import 'package:attendance_management/src/home/domain/entities/absence.dart' show Absence;
import 'package:attendance_management/src/home/domain/usecases/get_absences.dart'
    show GetAbsences;
import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAbsences extends Mock implements GetAbsences {}

void main() {
  late GetAbsences mockGetAbsences;
  late AbsencesBloc bloc;
  late List<Absence> mockAbsences;
  final tFailure = FileFailure(
    message: 'Failed to load absences',
    statusCode: 4032,
  );
  setUp(() {
    mockGetAbsences = MockGetAbsences();
    bloc = AbsencesBloc(getAbsences: mockGetAbsences);

    mockAbsences = [
      Absence(
        id: 1,
        name: "John Doe",
        type: "Sickness",
        startDate: "2024-03-01",
        endDate: "2024-03-05",
        status: "confirmed",
        createdAt: "2024-03-01",
        crewId: 1,
        userId: 1,
      ),
      Absence(
        id: 2,
        name: "Jane Smith",
        type: "Vacation",
        startDate: "2024-03-10",
        endDate: "2024-03-15",
        status: "pending",
        createdAt: "2024-03-01",
        crewId: 2,
        userId: 2,
      ),
    ];
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be [AbsenceInitial] ', () async {
    expect(bloc.state, const AbsenceInitial());
  });

  group('getAbsences', () {
    blocTest<AbsencesBloc, AbsencesState>(
      'should emit [AbsencesLoading, AbsencesLoaded] when '
      'getAbsences is called',
      build: () {
        when(() => mockGetAbsences()).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAbsencesEvent()),
      expect:
          () => const [
            AbsencesLoading(),
            AbsencesLoaded(
              absences: [],
              hasMore: false,
              totalAbsences: [],
              type: null,
              startDate: null,
              endDate: null,
            ),
          ],
      verify: (_) {
        verify(() => mockGetAbsences()).called(1);
        verifyNoMoreInteractions(mockGetAbsences);
      },
    );
    blocTest<AbsencesBloc, AbsencesState>(
      'should emit [AbsencesLoading, AbsencesError] when getAbsences '
      'is unsuccessful',
      build: () {
        when(() => mockGetAbsences()).thenAnswer((_) async => Left(tFailure));
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
        verify(() => mockGetAbsences()).called(1);
        verifyNoMoreInteractions(mockGetAbsences);
      },
    );
  });

  blocTest<AbsencesBloc, AbsencesState>(
    "Emits [AbsencesLoading, AbsencesLoaded] when LoadAbsencesEvent is added",
    build: () {
      when(() => mockGetAbsences()).thenAnswer((_) async => Right(mockAbsences));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadAbsencesEvent()),
    expect: () => [
      AbsencesLoading(),
      AbsencesLoaded(
        absences: mockAbsences.take(10).toList(),
        hasMore: false,
        totalAbsences: mockAbsences,
        type: null,
        startDate: null,
        endDate: null,
      ),
    ],
  );

  blocTest<AbsencesBloc, AbsencesState>(
    "Emits [AbsencesLoading, AbsencesError] when LoadAbsencesEvent fails",
    build: () {
      when(() => mockGetAbsences()).thenAnswer((_) async => Left(tFailure));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadAbsencesEvent()),
    expect: () => [
      AbsencesLoading(),
      AbsencesError(message: "Failed to load absences"),
    ],
  );

  blocTest<AbsencesBloc, AbsencesState>(
    "Emits AbsencesExporting when ExportingAbsencesEvent is added",
    build: () => bloc,
    act: (bloc) => bloc.add(ExportingAbsencesEvent()),
    expect: () => [AbsencesExporting(totalAbsences: [])],
  );

  blocTest<AbsencesBloc, AbsencesState>(
    "Emits AbsencesExported when ExportingAbsencesSuccessEvent is added",
    build: () => bloc,
    act: (bloc) => bloc.add(ExportingAbsencesSuccessEvent()),
    expect: () => [AbsencesExported()],
  );

  blocTest<AbsencesBloc, AbsencesState>(
    "Emits AbsencesExportError when ExportingAbsencesErrorEvent is added",
    build: () => bloc,
    act: (bloc) => bloc.add(ExportingAbsencesErrorEvent(message: "Export failed")),
    expect: () => [AbsencesExportError(message: "Export failed")],
  );
}
