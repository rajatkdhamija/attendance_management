import 'package:attendance_management/src/home/domain/entities/absence.dart'
    show Absence;
import 'package:attendance_management/src/home/domain/usecases/get_absences.dart'
    show GetAbsences;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'absence_event.dart';

part 'absence_state.dart';

class AbsenceBloc extends Bloc<AbsenceEvent, AbsenceState> {
  AbsenceBloc({required GetAbsences getAbsences})
    : _getAbsences = getAbsences,
      super(const AbsenceInitial()) {
    on<LoadAbsencesEvent>(_getAbsencesHandler);
  }

  final GetAbsences _getAbsences;

  Future<void> _getAbsencesHandler(
    LoadAbsencesEvent event,
    Emitter<AbsenceState> emit,
  ) async {
    emit(const AbsencesLoading());
    final result = await _getAbsences();
    result.fold(
      (failure) =>
          emit(const AbsencesError(message: 'Failed to load absences')),
      (absences) => emit(AbsencesLoaded(absences: absences)),
    );
  }
}
