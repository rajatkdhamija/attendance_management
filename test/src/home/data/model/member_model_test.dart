import 'dart:convert' show jsonDecode;

import 'package:attendance_management/core/utils/typedefs.dart' show DataMap;
import 'package:attendance_management/src/home/data/model/member_model.dart'
    show MemberModel;
import 'package:attendance_management/src/home/domain/entities/member.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart' show fixture;

void main() {
  const tMemberModel = MemberModel.empty();

  test('should be a subclass of [Member] entity', () {
    expect(tMemberModel, isA<Member>());
  });

  final tMap = jsonDecode(fixture('member.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [MemberModel] from the map', () {
      final result = MemberModel.fromMap(tMap);
      expect(result, tMemberModel);
    });

    test('should throw and error when map is invalid', () async {
      final map = DataMap.from(tMap)..remove('id');
      const result = MemberModel.fromMap;
      expect(() => result(map), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from the model', () {
      final result = tMemberModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a valid [MemberModel] with updated values', () {
      final result = tMemberModel.copyWith(id: 2);
      expect(result.id, 2);
    });
  });
}
