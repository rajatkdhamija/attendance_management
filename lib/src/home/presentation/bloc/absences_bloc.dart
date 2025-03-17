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
    on<LoadMoreAbsencesEvent>(_loadMoreAbsencesHandler);
  }

  final GetAbsences _getAbsences;
  List<Absence> _allAbsences = [];
  List<Absence> _paginatedAbsences = [];
  int _currentPage = 1;
  static const int _limit = 10;
  bool _hasMore = true;

  Future<void> _getAbsencesHandler(
    LoadAbsencesEvent event,
    Emitter<AbsencesState> emit,
  ) async {
    emit(const AbsencesLoading());
    _currentPage = 1;
    _hasMore = true;

    final result = await _getAbsences();

    result.fold(
      (failure) =>
          emit(const AbsencesError(message: 'Failed to load absences')),
      (absences) {
        _allAbsences = absences;
        _paginatedAbsences = _allAbsences.take(_limit).toList();
        _hasMore = _allAbsences.length > _limit;
        emit(AbsencesLoaded(absences: _paginatedAbsences, hasMore: _hasMore));
      },
    );
  }

  void _loadMoreAbsencesHandler(
      LoadMoreAbsencesEvent event,
      Emitter<AbsencesState> emit,
      ) {
    if (!_hasMore) return;

    _currentPage++;
    int startIndex = (_currentPage - 1) * _limit;
    int endIndex = startIndex + _limit;

    if (startIndex < _allAbsences.length) {
      final newAbsences = _allAbsences.sublist(
        startIndex,
        endIndex > _allAbsences.length ? _allAbsences.length : endIndex,
      );

      _paginatedAbsences.addAll(newAbsences);
      _hasMore = _paginatedAbsences.length < _allAbsences.length;

      emit(AbsencesLoaded(absences: List.from(_paginatedAbsences), hasMore: _hasMore));
    }
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

      filteredAbsences =
          filteredAbsences.where((absence) {
            DateTime absenceStartDate =
                DateTime.parse(absence.startDate).toLocal();
            DateTime absenceEndDate = DateTime.parse(absence.endDate).toLocal();

            bool isAfterStart =
                absenceStartDate.isAtSameMomentAs(parsedStartDate) ||
                absenceStartDate.isAfter(parsedStartDate);
            bool isBeforeEnd =
                absenceEndDate.isAtSameMomentAs(parsedEndDate) ||
                absenceEndDate.isBefore(parsedEndDate);

            return isAfterStart && isBeforeEnd;
          }).toList();
    }

    _paginatedAbsences = filteredAbsences.take(_limit).toList();
    _hasMore = filteredAbsences.length > _limit;

    emit(
      AbsencesFiltered(
        absences: _paginatedAbsences,
        type: event.type,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
  }
}
