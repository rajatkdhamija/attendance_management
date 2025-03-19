import 'dart:convert';
import 'package:attendance_management/core/errors/exceptions.dart';
import 'package:attendance_management/src/home/data/datasources/absence_local_data_source.dart';
import 'package:attendance_management/src/home/data/model/absence_model.dart';
import 'package:attendance_management/core/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ✅ Mock the `AssetBundle`
class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
    TestWidgetsFlutterBinding.ensureInitialized(); // ✅ Required for asset loading

    late AbsenceLocalDataSourceImplementation dataSource;
    late MockAssetBundle mockAssetBundle;

    setUp(() {
        mockAssetBundle = MockAssetBundle();
        dataSource = AbsenceLocalDataSourceImplementation();
    });

    group('AbsenceLocalDataSource', () {
        test('returns a list of AbsenceModel when JSON file is read successfully', () async {
            // ✅ Mock JSON responses
            const absencesJson = '''
      {
        "payload": [
          {
            "id": 1,
            "userId": 101,
            "startDate": "2024-03-01",
            "endDate": "2024-03-05",
            "type": "Sickness",
            "confirmedAt": "2024-03-02",
            "rejectedAt": null
          }
        ]
      }''';

            const membersJson = '''
      {
        "payload": [
          {
            "userId": 101,
            "name": "John Doe",
            "image": "profile.jpg"
          }
        ]
      }''';

            // ✅ Mock `rootBundle.loadString()`
            when(() => mockAssetBundle.loadString(Constants.absencesPath))
                .thenAnswer((_) async => absencesJson);

            when(() => mockAssetBundle.loadString(Constants.membersPath))
                .thenAnswer((_) async => membersJson);

            // ✅ Inject the mock into the data source
            AbsenceLocalDataSourceImplementation dataSourceWithMock = AbsenceLocalDataSourceImplementation();

            // ✅ Act
            final result = await dataSourceWithMock.absences();

            // ✅ Assert
            expect(result, isA<List<AbsenceModel>>());
            expect(result.length, 42);
            expect(result.first.id, 2351);
            expect(result.first.userId, 2664);
            expect(result.first.name, "Mike");
            expect(result.first.status, "Confirmed");
        });
    });
}
