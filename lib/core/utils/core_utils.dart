import 'dart:io';

import 'package:attendance_management/core/res/colours.dart' show Colours;
import 'package:attendance_management/src/home/domain/entities/absence.dart';
import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colours.primaryColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
  }

  static Future<void> exportAbsencesToICal(
      BuildContext context,
      VoidCallback onCreateSuccess,
      VoidCallback onCreateFailure,
      ) async {
    try {
      final state = context.read<AbsencesBloc>().state;
      final List<Absence> absences;

      if (state is AbsencesLoaded) {
        absences = state.totalAbsences;
      } else if (state is AbsencesFiltered) {
        absences = state.totalAbsences;
      } else if (state is AbsencesExporting){
        absences = state.totalAbsences;
      }
      else {
        return;
      }

      String? icsContent = await compute(_generateICalContent, absences);

      if (icsContent != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/absences_${DateTime.now().millisecondsSinceEpoch}.ics';
        final file = File(filePath);
        await file.writeAsString(icsContent);

        XFile xFile = XFile(filePath);
        Share.shareXFiles([xFile]);

        onCreateSuccess();
      } else {
        onCreateFailure();
      }
    } catch (e) {
      onCreateFailure();
    }
  }

  static String? _generateICalContent(List<Absence> absences) {
    try {
      StringBuffer icsContent = StringBuffer();
      icsContent.writeln('BEGIN:VCALENDAR');
      icsContent.writeln('VERSION:2.0');
      icsContent.writeln('PRODID:-//YourApp//NONSGML v1.0//EN');

      for (var absence in absences) {
        String uid = absence.id.toString();
        String dtStart = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(
            DateTime.parse(absence.startDate).toUtc());

        String dtEnd = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(
            DateTime.parse(absence.endDate).toUtc());

        icsContent.writeln('BEGIN:VEVENT');
        icsContent.writeln('UID:$uid');
        icsContent.writeln('DTSTAMP:$dtStart');
        icsContent.writeln('DTSTART:$dtStart');
        icsContent.writeln('DTEND:$dtEnd');
        icsContent.writeln('SUMMARY:Absent - ${absence.name}');
        if (absence.memberNote != null) {
          icsContent.writeln('DESCRIPTION:MemberNote: ${absence.memberNote}');
        }
        if (absence.admitterNote != null) {
          icsContent.writeln('DESCRIPTION:ManagerNote: ${absence.admitterNote}');
        }
        if (absence.status != null) {
          icsContent.writeln('DESCRIPTION:Status: ${absence.status}');
        }
        icsContent.writeln('END:VEVENT');
      }

      icsContent.writeln('END:VCALENDAR');
      return icsContent.toString();
    } catch (e) {
      return null;
    }
  }
}
