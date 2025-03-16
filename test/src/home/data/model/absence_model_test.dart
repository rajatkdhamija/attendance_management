import 'dart:convert';

import 'package:attendance_management/core/utils/typedefs.dart' show DataMap;
import 'package:attendance_management/src/home/data/model/absence_model.dart'
    show AbsenceModel;
import 'package:attendance_management/src/home/domain/entities/absence.dart'
    show Absence;
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart' show fixture;

void main() {
  const tAbsenceModel = AbsenceModel.empty();

  test('should be a subclass of [Absence] entity', () {
    expect(tAbsenceModel, isA<Absence>());
  });

  final tMap = jsonDecode(fixture('absence.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [AbsenceModel] from the map', () {
      final result = AbsenceModel.fromMap(tMap);
      expect(result, tAbsenceModel);
    });

    test('should throw and error when map is invalid', () async {
      final map = DataMap.from(tMap)..remove('id');
      const result = AbsenceModel.fromMap;
      expect(() => result(map), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from the model', () {
      final result = tAbsenceModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a valid [AbsenceModel] with updated values', () {
      final result = tAbsenceModel.copyWith(id: 2);
      expect(result.id, 2);
    });
  });
}
