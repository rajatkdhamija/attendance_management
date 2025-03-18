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
  const AbsencesLoaded({
    required this.absences,
    required this.hasMore,
    required this.totalAbsences,
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  final List<Absence> absences;
  final bool hasMore;
  final List<Absence> totalAbsences;
  final String? type;
  final String? startDate;
  final String? endDate;

  @override
  List<Object> get props => [absences, hasMore, totalAbsences];
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

class AbsencesExported extends AbsencesState {
  const AbsencesExported();
}

class AbsencesExporting extends AbsencesState {
  final List<Absence> totalAbsences;

  const AbsencesExporting({required this.totalAbsences});
}

class AbsencesExportError extends AbsencesState {
  const AbsencesExportError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}


class AbsencesFiltered extends AbsencesState {
  final List<Absence> absences;
  final String? type;
  final String? startDate;
  final String? endDate;
  final List<Absence> totalAbsences;

  const AbsencesFiltered({
    required this.absences,
    this.type,
    this.startDate,
    this.endDate,
    required this.totalAbsences,
  });

  @override
  List<Object> get props => [
    absences,
    type ?? '',
    startDate ?? '',
    endDate ?? '',
  ];
}
