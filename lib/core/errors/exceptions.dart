import 'package:equatable/equatable.dart' show Equatable;

class FileException extends Equatable implements Exception {
  const FileException({required this.message, required this.statusCode});

  final String message;
  final String statusCode;

  @override
  List<dynamic> get props => [message, statusCode];
}
