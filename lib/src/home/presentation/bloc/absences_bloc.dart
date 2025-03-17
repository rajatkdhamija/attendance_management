import 'package:attendance_management/src/home/domain/entities/absence.dart'
    show Absence;
import 'package:attendance_management/src/home/domain/usecases/get_absences.dart'
    show GetAbsences;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'absences_event.dart';

part 'absences_state.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  AbsencesBloc({required GetAbsences getAbsences})
    : _getAbsences = getAbsences,
      super(const AbsenceInitial()) {
    on<LoadAbsencesEvent>(_getAbsencesHandler);
    on<FilterAbsencesEvent>(_filterAbsencesHandler);
  }

  final GetAbsences _getAbsences;
  List<Absence> _allAbsences = [];

  Future<void> _getAbsencesHandler(
    LoadAbsencesEvent event,
    Emitter<AbsencesState> emit,
  ) async {
    emit(const AbsencesLoading());
    final result = await _getAbsences();
    result.fold(
      (failure) =>
          emit(const AbsencesError(message: 'Failed to load absences')),
      (absences) {
        _allAbsences = absences;
        emit(AbsencesLoaded(absences: absences));
      },
    );
  }

  void _filterAbsencesHandler(
    FilterAbsencesEvent event,
    Emitter<AbsencesState> emit,
  ) {
    List<Absence> filteredAbsences = _allAbsences;

    if (event.type != null) {
      if (event.type?.toLowerCase() == 'other') {
        filteredAbsences =
            filteredAbsences
                .where(
                  (absence) =>
                      absence.type == null ||
                      absence.type!.isEmpty ||
                      (absence.type!.toLowerCase() != 'sickness' &&
                          absence.type!.toLowerCase() != 'vacation'),
                )
                .toList();
      } else {
        filteredAbsences =
            filteredAbsences
                .where(
                  (absence) =>
                      absence.type?.toLowerCase() == event.type?.toLowerCase(),
                )
                .toList();
      }
    }
    if (event.startDate != null && event.endDate != null) {
      DateTime parsedStartDate = DateTime.parse(event.startDate!).toLocal();
      DateTime parsedEndDate = DateTime.parse(event.endDate!).toLocal();

      filteredAbsences = filteredAbsences.where((absence) {
        DateTime absenceStartDate = DateTime.parse(absence.startDate).toLocal();
        DateTime absenceEndDate = DateTime.parse(absence.endDate).toLocal();

        bool isAfterStart = absenceStartDate.isAtSameMomentAs(parsedStartDate) || absenceStartDate.isAfter(parsedStartDate);
        bool isBeforeEnd = absenceEndDate.isAtSameMomentAs(parsedEndDate) || absenceEndDate.isBefore(parsedEndDate);

        return isAfterStart && isBeforeEnd;
      }).toList();
    }

    emit(
      AbsencesFiltered(
        absences: filteredAbsences,
        type: event.type,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
  }
}
