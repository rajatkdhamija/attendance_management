import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateFilterButtons extends StatelessWidget {
  const DateFilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsencesBloc, AbsencesState>(
      buildWhen: (previous, current) {
        return current is AbsencesFiltered;
      },
      builder: (context, state) {
        String? startDate;
        String? endDate;

        if (state is AbsencesFiltered) {
          startDate = state.startDate ?? startDate;
          endDate = state.endDate ?? endDate;
        }

        return Row(
          children: [
            Expanded(
              child: _buildDateButton(
                context,
                'Start Date',
                'Start',
                startDate,
                true,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildDateButton(
                context,
                'End Date',
                'End',
                endDate,
                false,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateButton(
    BuildContext context,
    String label,
    String labelShort,
    String? date,
    bool isStart,
  ) {
    return ElevatedButton(
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date != null ? DateTime.parse(date) : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null && context.mounted) {
          context.read<AbsencesBloc>().add(
            FilterAbsencesEvent(
              startDate: isStart ? picked.toIso8601String() : null,
              endDate: isStart ? null : picked.toIso8601String(),
            ),
          );
        }
      },
      child: Text(
        date != null
            ? '$labelShort: ${DateFormat('dd MMM yyyy').format(DateTime.parse(date))}'
            : 'Select $label',
      ),
    );
  }
}
