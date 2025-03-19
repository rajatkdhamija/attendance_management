import 'package:attendance_management/core/utils/typedefs.dart'
    show ResultFuture;

abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();

  ResultFuture<Type> call();
}
