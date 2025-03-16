import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:attendance_management/core/utils/constants.dart' show Constants;
import 'package:attendance_management/src/home/data/model/absence_model.dart';

abstract class AbsenceLocalDataSource {
  const AbsenceLocalDataSource();

  Future<List<AbsenceModel>> absences();
}

class AbsenceLocalDataSourceImplementation
    implements AbsenceLocalDataSource {
  Future<List<dynamic>> readJsonFile(String path) async {
    String content = await File(path).readAsString();
    Map<String, dynamic> data = jsonDecode(content);
    return data['payload'];
  }

  @override
  Future<List<AbsenceModel>> absences() async {
    final jsonList = await readJsonFile(Constants.absencesPath);
    return jsonList
        .map((json) => AbsenceModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
