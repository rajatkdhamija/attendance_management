import 'package:attendance_management/core/errors/failure.dart' show Failure;
import 'package:dartz/dartz.dart' show Either;

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
