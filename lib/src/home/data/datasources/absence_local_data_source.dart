import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:attendance_management/core/errors/exceptions.dart';
import 'package:attendance_management/core/utils/constants.dart' show Constants;
import 'package:attendance_management/src/home/data/model/absence_model.dart';
import 'package:flutter/services.dart' show rootBundle;

abstract class AbsenceLocalDataSource {
  const AbsenceLocalDataSource();

  Future<List<AbsenceModel>> absences();
}

class AbsenceLocalDataSourceImplementation implements AbsenceLocalDataSource {
  Future<List<dynamic>> readJsonFile(String path) async {
    String content = await File(path).readAsString();
    Map<String, dynamic> data = jsonDecode(content);
    return data['payload'];
  }

  Future<String> readLocalJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Future<List<AbsenceModel>> absences() async {
    try {
      final absencesJson = await readLocalJsonFile(Constants.absencesPath);
      final absencesData = jsonDecode(absencesJson)['payload'] as List<dynamic>;

      final membersJson = await readLocalJsonFile(Constants.membersPath);
      final membersData = jsonDecode(membersJson)['payload'] as List<dynamic>;

      final Map<int, Map<String, String>> membersMap = {
        for (var member in membersData)
          member['userId']: {
            'name': member['name'] as String,
            'image': member['image'] as String,
          },
      };

      return absencesData
          .map((json) => AbsenceModel.fromJson(json, membersMap))
          .toList();
    } catch (e) {
      throw FileException(message: 'Failed to read file', statusCode: '404');
    }
  }
}
