part of 'absence_bloc.dart';

sealed class AbsenceEvent extends Equatable {
  const AbsenceEvent();

  @override
  List<Object> get props => [];
}

class LoadAbsencesEvent extends AbsenceEvent {
  const LoadAbsencesEvent();
}

class FilterAbsencesEvent extends AbsenceEvent {
  const FilterAbsencesEvent({required this.filter});
  final String filter;

  @override
  List<Object> get props => [filter];
}

