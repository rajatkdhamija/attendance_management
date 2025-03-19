import 'package:flutter_test/flutter_test.dart';
import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';

void main() {
  group('AbsencesEvent', () {
    test('LoadAbsencesEvent should support value equality', () {
      expect(const LoadAbsencesEvent(), equals(const LoadAbsencesEvent()));
    });

    test('LoadMoreAbsencesEvent should support value equality', () {
      expect(const LoadMoreAbsencesEvent(), equals(const LoadMoreAbsencesEvent()));
    });

    test('ResetFilterAbsencesEvent should support value equality', () {
      expect(const ResetFilterAbsencesEvent(), equals(const ResetFilterAbsencesEvent()));
    });

    test('FilterAbsencesEvent should support value equality', () {
      expect(
        const FilterAbsencesEvent(type: 'vacation', startDate: '2024-03-01', endDate: '2024-03-10'),
        equals(const FilterAbsencesEvent(type: 'vacation', startDate: '2024-03-01', endDate: '2024-03-10')),
      );
    });

    test('FilterAbsencesEvent should override props correctly', () {
      const event1 = FilterAbsencesEvent(type: 'sickness', startDate: '2024-02-01', endDate: '2024-02-05');
      const event2 = FilterAbsencesEvent(type: 'sickness', startDate: '2024-02-01', endDate: '2024-02-05');
      const event3 = FilterAbsencesEvent(type: 'vacation', startDate: '2024-03-01', endDate: '2024-03-10');

      expect(event1.props, equals(event2.props)); // Same values, should be equal
      expect(event1.props, isNot(equals(event3.props))); // Different values, should not be equal
    });

    test('ExportingAbsencesEvent should support value equality', () {
      expect(const ExportingAbsencesEvent(), equals(const ExportingAbsencesEvent()));
    });

    test('ExportingAbsencesSuccessEvent should support value equality', () {
      expect(const ExportingAbsencesSuccessEvent(), equals(const ExportingAbsencesSuccessEvent()));
    });

    test('ExportingAbsencesErrorEvent should support value equality', () {
      expect(
        const ExportingAbsencesErrorEvent(message: 'Error occurred'),
        equals(const ExportingAbsencesErrorEvent(message: 'Error occurred')),
      );
    });

    test('ExportingAbsencesErrorEvent should override props correctly', () {
      const event1 = ExportingAbsencesErrorEvent(message: 'Network issue');
      const event2 = ExportingAbsencesErrorEvent(message: 'Network issue');
      const event3 = ExportingAbsencesErrorEvent(message: 'Server error');

      expect(event1.props, equals(event2.props)); // Same message, should be equal
      expect(event1.props, isNot(equals(event3.props))); // Different message, should not be equal
    });
  });
}
