part of 'absences_bloc.dart';

sealed class AbsencesState extends Equatable {
  const AbsencesState();

  @override
  List<Object> get props => [];
}

final class AbsenceInitial extends AbsencesState {
  const AbsenceInitial();
}

class AbsencesLoading extends AbsencesState {
  const AbsencesLoading();
}

class AbsencesLoaded extends AbsencesState {
  const AbsencesLoaded({required this.absences, required this.hasMore});

  final List<Absence> absences;
  final bool hasMore;

  @override
  List<Object> get props => [absences, hasMore];
}

class AbsencesError extends AbsencesState {
  const AbsencesError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class AbsencesEmpty extends AbsencesState {
  const AbsencesEmpty();
}

class AbsencesLoadingMore extends AbsencesState {
  const AbsencesLoadingMore();
}


class AbsencesFiltered extends AbsencesState {
  final List<Absence> absences;
  final String? type;
  final String? startDate;
  final String? endDate;

  const AbsencesFiltered({required this.absences, this.type, this.startDate, this.endDate});

  @override
  List<Object> get props => [absences, type ?? '', startDate ?? '', endDate ?? ''];
}

