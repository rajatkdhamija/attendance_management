import 'package:attendance_management/core/res/colours.dart';
import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalAbsencesText extends StatelessWidget {
  const TotalAbsencesText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsencesBloc, AbsencesState>(
      buildWhen: (previous, current) {
        return current is AbsencesLoaded || current is AbsencesFiltered;
      },
      builder: (context, state) {
        if (state is AbsencesLoaded || state is AbsencesFiltered) {
          var totalAbsences = 0;
          if (state is AbsencesLoaded) {
            totalAbsences = state.totalAbsences.length;
          } else if (state is AbsencesFiltered) {
            totalAbsences = state.totalAbsences.length;
          }
          return Text(
            "Total Absences: $totalAbsences",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colours.primaryColour,
            ),
          );
        }
        return SizedBox.shrink(); // Hide if not loaded
      },
    );
  }
}
