part of 'absence_bloc.dart';

sealed class AbsenceState extends Equatable {
  const AbsenceState();

  @override
  List<Object> get props => [];
}

final class AbsenceInitial extends AbsenceState {
  const AbsenceInitial();
}

class AbsencesLoading extends AbsenceState {
  const AbsencesLoading();
}

class AbsencesLoaded extends AbsenceState {
  const AbsencesLoaded({required this.absences});
  final List<Absence> absences;

  @override
  List<Object> get props => [absences];
}

class AbsencesError extends AbsenceState {
  const AbsencesError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class AbsenceEmpty extends AbsenceState {
  const AbsenceEmpty();
}


