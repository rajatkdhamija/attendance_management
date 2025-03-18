import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
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
          return _buildErrorUI(context);
        } else if (state is AbsencesEmpty) {
          return _buildEmptyUI();
        } else if (state is AbsencesLoaded || state is AbsencesFiltered) {
          final hasMore = state is AbsencesLoaded ? state.hasMore : false;

          final absences =
              state is AbsencesFiltered
                  ? state.absences
                  : (state as AbsencesLoaded).absences;
          if (absences.isEmpty) return _buildEmptyUI();
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
                    backgroundImage: _buildImage(absence.image),
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
                        'Start: ${_formatDate(absence.startDate)}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'End: ${_formatDate(absence.endDate)}',
                        style: TextStyle(fontSize: 14),
                      ),
                      (absence.memberNote != null &&
                              absence.memberNote!.isNotEmpty)
                          ? Text(
                            'Member\'s Note: ${absence.memberNote}',
                            style: TextStyle(fontSize: 14),
                          )
                          : SizedBox.shrink(),
                      (absence.admitterNote != null &&
                              absence.admitterNote!.isNotEmpty)
                          ? Text(
                            'Admitter\'s Note: ${absence.admitterNote}',
                            style: TextStyle(fontSize: 14),
                          )
                          : SizedBox.shrink(),
                      if (absence.status != null)
                        Text(
                          'Status: ${absence.status}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
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

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "Unknown";
    }

    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  Widget _buildErrorUI(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
            SizedBox(height: 10),
            Text(
              "Oops! Something went wrong.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Failed to load absences. Please check your connection or try again.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AbsencesBloc>().add(
                  LoadAbsencesEvent(),
                ); // Retry logic
              },
              icon: Icon(Icons.refresh),
              label: Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              "No Absences Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "There are no recorded absences at the moment.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

_buildImage(String? image) {
  try{
    if(image == null || image.isEmpty) {
      return NetworkImage('https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_1280.png');
    }
    return NetworkImage(image);
  }catch(e){
    return NetworkImage('https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_1280.png');
  }
}
