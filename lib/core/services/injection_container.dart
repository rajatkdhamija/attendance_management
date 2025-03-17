import 'package:attendance_management/src/home/data/datasources/absence_local_data_source.dart';
import 'package:attendance_management/src/home/data/repos/absence_repository_implementation.dart';
import 'package:attendance_management/src/home/domain/repos/absence_repository.dart';
import 'package:attendance_management/src/home/domain/usecases/get_absences.dart';
import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:get_it/get_it.dart' show GetIt;

final sl = GetIt.instance;

Future<void> init() async {
  await _iniHome();
}

Future<void> _iniHome() async {
  sl
    ..registerLazySingleton(() => AbsencesBloc(getAbsences: sl()))
    ..registerLazySingleton(() => GetAbsences(sl()))
    ..registerLazySingleton<AbsenceRepository>(
      () => AbsenceRepositoryImplementation(sl()),
    )
    ..registerLazySingleton<AbsenceLocalDataSource>(
      () => AbsenceLocalDataSourceImplementation(),
    );
}
