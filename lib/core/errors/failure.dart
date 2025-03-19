import 'package:equatable/equatable.dart' show Equatable;

abstract class Failure extends Equatable {
  Failure({required this.message, required this.statusCode})
    : assert(
        statusCode is String || statusCode is int,
        'StatusCode cannot be a ${statusCode.runtimeType}',
      );

  final String message;
  final dynamic statusCode;

  String get errorMessage => '''
$statusCode ${statusCode is String ? '' : 'Error'}: $message''';

  @override
  List<dynamic> get props => [message, statusCode];
}

class FileFailure extends Failure {
  FileFailure({required super.message, required super.statusCode});
}
