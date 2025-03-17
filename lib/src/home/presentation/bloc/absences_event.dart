part of 'absences_bloc.dart';

sealed class AbsencesEvent extends Equatable {
  const AbsencesEvent();

  @override
  List<Object> get props => [];
}

class LoadAbsencesEvent extends AbsencesEvent {
  const LoadAbsencesEvent();
}

class LoadMoreAbsencesEvent extends AbsencesEvent {
  const LoadMoreAbsencesEvent();
}

class FilterAbsencesEvent extends AbsencesEvent {
  final String? type;
  final String? startDate;
  final String? endDate;

  const FilterAbsencesEvent({this.type, this.startDate, this.endDate});

  @override
  List<Object> get props => [type ?? '', startDate ?? '', endDate ?? ''];
}
