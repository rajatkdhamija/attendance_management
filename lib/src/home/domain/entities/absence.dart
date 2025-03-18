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
  final String? type;
  final int userId;
  final String? memberNote;
  final String? rejectedAt;
  final String? name;
  final String? image;
  final String? status;

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
    this.name,
    this.image,
    this.status,
  });

  @override
  List<Object?> get props => [id, userId];
}
