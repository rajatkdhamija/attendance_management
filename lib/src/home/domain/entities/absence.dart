import 'package:equatable/equatable.dart' show Equatable;

class Absence extends Equatable {
  final int id;
  final int? admitterId;
  final String? admitterNote;
  final String? confirmedAt;
  final String createdAt;
  final int crewId;
  final String endDate;
  final String startDate;
  final String type;
  final int userId;
  final String? memberNote;
  final String? rejectedAt;

  const Absence({
    required this.id,
    this.admitterId,
    this.admitterNote,
    this.confirmedAt,
    required this.createdAt,
    required this.crewId,
    required this.endDate,
    required this.startDate,
    required this.type,
    required this.userId,
    this.memberNote,
    this.rejectedAt,
  });

  @override
  List<Object?> get props => [id, userId];
}
