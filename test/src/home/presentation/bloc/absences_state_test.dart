import 'package:flutter_test/flutter_test.dart';
import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:attendance_management/src/home/domain/entities/absence.dart';

void main() {
  group('AbsencesState', () {
    test('AbsenceInitial should support value equality', () {
      expect(const AbsenceInitial(), equals(const AbsenceInitial()));
    });

    test('AbsencesLoading should support value equality', () {
      expect(const AbsencesLoading(), equals(const AbsencesLoading()));
    });

    test('AbsencesEmpty should support value equality', () {
      expect(const AbsencesEmpty(), equals(const AbsencesEmpty()));
    });

    test('AbsencesLoadingMore should support value equality', () {
      expect(const AbsencesLoadingMore(), equals(const AbsencesLoadingMore()));
    });

    test('AbsencesExported should support value equality', () {
      expect(const AbsencesExported(), equals(const AbsencesExported()));
    });

    test('AbsencesError should support value equality', () {
      expect(
        const AbsencesError(message: 'Error occurred'),
        equals(const AbsencesError(message: 'Error occurred')),
      );
    });

    test('AbsencesError should override props correctly', () {
      const state1 = AbsencesError(message: 'Network issue');
      const state2 = AbsencesError(message: 'Network issue');
      const state3 = AbsencesError(message: 'Server error');

      expect(state1.props, equals(state2.props)); // Same message, should be equal
      expect(state1.props, isNot(equals(state3.props))); // Different message, should not be equal
    });

    test('AbsencesExportError should support value equality', () {
      expect(
        const AbsencesExportError(message: 'Export failed'),
        equals(const AbsencesExportError(message: 'Export failed')),
      );
    });

    test('AbsencesExportError should override props correctly', () {
      const state1 = AbsencesExportError(message: 'File not found');
      const state2 = AbsencesExportError(message: 'File not found');
      const state3 = AbsencesExportError(message: 'Permission denied');

      expect(state1.props, equals(state2.props));
      expect(state1.props, isNot(equals(state3.props)));
    });

    test('AbsencesExporting should support value equality', () {
      final sampleAbsences = [
        Absence(userId: 1, startDate: '2024-03-18', endDate: '2024-03-20', type: 'vacation', id: 1, name: 'John Doe', status: 'confirmed', createdAt: '2024-03-01', crewId: 1),
      ];

      expect(
        AbsencesExporting(totalAbsences: sampleAbsences),
        equals(AbsencesExporting(totalAbsences: sampleAbsences)),
      );
    });

    test('AbsencesFiltered should support value equality', () {
      final sampleAbsences = [
        Absence(userId: 1, startDate: '2024-03-18', endDate: '2024-03-20', type: 'vacation', id: 1, name: 'John Doe', status: 'confirmed', createdAt: '2024-03-01', crewId: 1),
      ];

      expect(
        AbsencesFiltered(
          absences: sampleAbsences,
          type: 'vacation',
          startDate: '2024-03-01',
          endDate: '2024-03-10',
          totalAbsences: sampleAbsences,
        ),
        equals(
          AbsencesFiltered(
            absences: sampleAbsences,
            type: 'vacation',
            startDate: '2024-03-01',
            endDate: '2024-03-10',
            totalAbsences: sampleAbsences,
          ),
        ),
      );
    });

    test('AbsencesFiltered should override props correctly', () {
      final absences1 = [
        Absence(userId: 1, startDate: '2024-03-18', endDate: '2024-03-20', type: 'vacation', id: 1, name: 'John Doe', status: 'confirmed', createdAt: '2024-03-01', crewId: 1),
      ];
      final absences2 = [
        Absence(userId: 2, startDate: '2024-03-19', endDate: '2024-03-21', type: 'sickness', id: 2, name: 'Jane Smith', status: 'pending', createdAt: '2024-03-01', crewId: 2),
      ];

      const state1 = AbsencesFiltered(
        absences: [],
        type: 'vacation',
        startDate: '2024-03-01',
        endDate: '2024-03-10',
        totalAbsences: [],
      );

      const state2 = AbsencesFiltered(
        absences: [],
        type: 'vacation',
        startDate: '2024-03-01',
        endDate: '2024-03-10',
        totalAbsences: [],
      );

      const state3 = AbsencesFiltered(
        absences: [],
        type: 'sickness',
        startDate: '2024-02-01',
        endDate: '2024-02-05',
        totalAbsences: [],
      );

      expect(state1.props, equals(state2.props)); // Same values, should be equal
      expect(state1.props, isNot(equals(state3.props))); // Different values, should not be equal
    });

    test('AbsencesLoaded should support value equality', () {
      final sampleAbsences = [
        Absence(userId: 1, startDate: '2024-03-18', endDate: '2024-03-20', type: 'vacation', id: 1, name: 'John Doe', status: 'confirmed', createdAt: '2024-03-01', crewId: 1),
      ];

      expect(
        AbsencesLoaded(
          absences: sampleAbsences,
          hasMore: true,
          totalAbsences: sampleAbsences,
          type: 'vacation',
          startDate: '2024-03-01',
          endDate: '2024-03-10',
        ),
        equals(
          AbsencesLoaded(
            absences: sampleAbsences,
            hasMore: true,
            totalAbsences: sampleAbsences,
            type: 'vacation',
            startDate: '2024-03-01',
            endDate: '2024-03-10',
          ),
        ),
      );
    });

    test('AbsencesLoaded should override props correctly', () {
      final absences1 = [
        Absence(userId: 1, startDate: '2024-03-18', endDate: '2024-03-20', type: 'vacation', id: 1, name: 'John Doe', status: 'confirmed', createdAt: '2024-03-01', crewId: 1),
      ];
      final absences2 = [
        Absence(userId: 2, startDate: '2024-03-19', endDate: '2024-03-21', type: 'sickness', id: 2, name: 'Jane Smith', status: 'pending', createdAt: '2024-03-01', crewId: 2),
      ];

      final state1 = AbsencesLoaded(
        absences: absences1,
        hasMore: true,
        totalAbsences: absences1,
        type: 'vacation',
        startDate: '2024-03-01',
        endDate: '2024-03-10',
      );

      final state2 = AbsencesLoaded(
        absences: absences1,
        hasMore: true,
        totalAbsences: absences1,
        type: 'vacation',
        startDate: '2024-03-01',
        endDate: '2024-03-10',
      );

      final state3 = AbsencesLoaded(
        absences: absences2,
        hasMore: false,
        totalAbsences: absences2,
        type: 'sickness',
        startDate: '2024-02-01',
        endDate: '2024-02-05',
      );

      expect(state1.props, equals(state2.props)); // Same values, should be equal
      expect(state1.props, isNot(equals(state3.props))); // Different values, should not be equal
    });
  });
}
