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

class ResetFilterAbsencesEvent extends AbsencesEvent {
  const ResetFilterAbsencesEvent();
}

class FilterAbsencesEvent extends AbsencesEvent {
  final String? type;
  final String? startDate;
  final String? endDate;

  const FilterAbsencesEvent({this.type, this.startDate, this.endDate});

  @override
  List<Object> get props => [type ?? '', startDate ?? '', endDate ?? ''];
}

class ExportingAbsencesEvent extends AbsencesEvent {
  const ExportingAbsencesEvent();
}

class ExportingAbsencesSuccessEvent extends AbsencesEvent {
  const ExportingAbsencesSuccessEvent();
}

class ExportingAbsencesErrorEvent extends AbsencesEvent {
  final String message;

  const ExportingAbsencesErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}
