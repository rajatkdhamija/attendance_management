import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:intl/intl.dart' show DateFormat;

class AbsencesList extends StatelessWidget {
  final ScrollController scrollController;

  const AbsencesList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsencesBloc, AbsencesState>(
      buildWhen: (previous, current) {
        return current is AbsencesLoading ||
            current is AbsencesError ||
            current is AbsencesEmpty ||
            current is AbsencesLoaded ||
            current is AbsencesFiltered;
      },
      builder: (context, state) {
        if (state is AbsencesLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AbsencesError) {
          return Center(child: Text('Failed to load absences'));
        } else if (state is AbsencesEmpty) {
          return Center(child: Text('No absences found'));
        } else if (state is AbsencesLoaded || state is AbsencesFiltered) {
          final hasMore = state is AbsencesLoaded ? state.hasMore : false;

          final absences =
              state is AbsencesFiltered
                  ? state.absences
                  : (state as AbsencesLoaded).absences;
          return ListView.builder(
            controller: scrollController,
            itemCount: absences.length + 1,
            itemBuilder: (context, index) {
              if (index == absences.length) {
                return hasMore
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }
              final absence = absences[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(absence.image ?? ''),
                    radius: 30,
                  ),
                  title: Text(
                    absence.name ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        'Type: ${absence.type}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Start: ${DateFormat('dd MMM yyyy').format(DateTime.parse(absence.startDate))}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'End: ${DateFormat('dd MMM yyyy').format(DateTime.parse(absence.endDate))}',
                        style: TextStyle(fontSize: 14),
                      ),
                      if (absence.status != null)
                        Text(
                          'Status: ${absence.status}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
