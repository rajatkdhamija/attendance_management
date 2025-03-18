import 'package:attendance_management/core/utils/core_utils.dart';
import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsencesBloc, AbsencesState>(
      builder: (context, state) {
        bool isExporting = state is AbsencesExporting;

        return ElevatedButton(
          onPressed:
              isExporting
                  ? null
                  : () {
                    context.read<AbsencesBloc>().add(ExportingAbsencesEvent());
                    Future.delayed(Duration.zero, () {
                      if (context.mounted) {
                        CoreUtils.exportAbsencesToICal(
                          context,
                          () {
                            context.read<AbsencesBloc>().add(
                              ExportingAbsencesSuccessEvent(),
                            );
                          },
                          () {
                            context.read<AbsencesBloc>().add(
                              ExportingAbsencesErrorEvent(
                                message: 'Failed to export to iCal',
                              ),
                            );
                            CoreUtils.showSnackBar(
                              context,
                              'Failed to export to iCal',
                            );
                          },
                        );
                      }
                    });
                  },
          child: Text(isExporting ? 'Exporting...' : 'Export to iCal'),
        );
      },
    );
  }
}
