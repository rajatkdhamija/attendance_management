import 'package:attendance_management/src/home/domain/entities/absence.dart';

class AbsenceModel extends Absence {
  const AbsenceModel({
    required super.id,
    super.admitterId,
    super.admitterNote,
    super.confirmedAt,
    required super.createdAt,
    required super.crewId,
    required super.endDate,
    required super.startDate,
    required super.type,
    required super.userId,
    super.memberNote,
    super.rejectedAt,
    required super.name,
    required super.image,
    required super.status,
  });

  const AbsenceModel.empty()
    : super(
        id: 0,
        admitterId: 0,
        admitterNote: '',
        confirmedAt: '',
        createdAt: '',
        crewId: 0,
        endDate: '',
        startDate: '',
        type: '',
        userId: 0,
        memberNote: '',
        rejectedAt: '',
        name: '',
        image: '',
        status: '',
      );

  factory AbsenceModel.fromJson(
    Map<String, dynamic> json,
    Map<int, Map<String, String>> membersMap,
  ) {
    int userId = json['userId'] as int;
    return AbsenceModel(
      id: json['id'] as int,
      admitterId: json['admitterId'] as int?,
      admitterNote: json['admitterNote'] as String?,
      confirmedAt: json['confirmedAt'] as String?,
      createdAt: json['createdAt'] as String,
      crewId: json['crewId'] as int,
      endDate: json['endDate'] as String,
      startDate: json['startDate'] as String,
      type: json['type'] as String,
      userId: userId,
      memberNote: json['memberNote'] as String?,
      rejectedAt: json['rejectedAt'] as String?,
      name: membersMap[userId]?['name'] ?? 'Unknown',
      image: membersMap[userId]?['image'] ?? '',
      status: json['status'] as String,
    );
  }

  factory AbsenceModel.fromMap(Map<String, dynamic> map) {
    return AbsenceModel(
      id: map['id'] as int,
      admitterId: map['admitterId'] as int?,
      admitterNote: map['admitterNote'] as String?,
      confirmedAt: map['confirmedAt'] as String?,
      createdAt: map['createdAt'] as String,
      crewId: map['crewId'] as int,
      endDate: map['endDate'] as String,
      startDate: map['startDate'] as String,
      type: map['type'] as String,
      userId: map['userId'] as int,
      memberNote: map['memberNote'] as String?,
      rejectedAt: map['rejectedAt'] as String?,
      name: map['name'] as String?,
      image: map['image'] as String?,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'admitterId': admitterId,
      'admitterNote': admitterNote,
      'confirmedAt': confirmedAt,
      'createdAt': createdAt,
      'crewId': crewId,
      'endDate': endDate,
      'startDate': startDate,
      'type': type,
      'userId': userId,
      'memberNote': memberNote,
      'rejectedAt': rejectedAt,
      'name': name,
      'image': image,
      'status': status,
    };
  }

  Absence copyWith({
    int? id,
    int? admitterId,
    String? admitterNote,
    String? confirmedAt,
    String? createdAt,
    int? crewId,
    String? endDate,
    String? startDate,
    String? type,
    int? userId,
    String? memberNote,
    String? rejectedAt,
    String? name,
    String? image,
    String? status,
  }) {
    return AbsenceModel(
      id: id ?? this.id,
      admitterId: admitterId ?? this.admitterId,
      admitterNote: admitterNote ?? this.admitterNote,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      createdAt: createdAt ?? this.createdAt,
      crewId: crewId ?? this.crewId,
      endDate: endDate ?? this.endDate,
      startDate: startDate ?? this.startDate,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      memberNote: memberNote ?? this.memberNote,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      name: name ?? this.name,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }
}
