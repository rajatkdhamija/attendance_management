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

      return absencesData.map((json) {
        // Determine status based on confirmedAt and rejectedAt
        String status;
        if (json['confirmedAt'] != null) {
          status = 'Confirmed';
        } else if (json['rejectedAt'] != null) {
          status = 'Rejected';
        } else {
          status = 'Pending';
        }

        return AbsenceModel.fromJson({...json, 'status': status}, membersMap);
      }).toList();
    } catch (e) {
      throw FileException(message: 'Failed to read file', statusCode: '404');
    }
  }
}
