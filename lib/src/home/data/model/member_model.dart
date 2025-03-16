import 'package:attendance_management/src/home/domain/entities/member.dart';

class MemberModel extends Member {
  const MemberModel({
    required super.id,
    required super.crewId,
    required super.image,
    required super.name,
    required super.userId,
  });

  const MemberModel.empty()
    : super(id: 0, crewId: 0, image: '', name: '', userId: 0);

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] as int,
      crewId: map['crewId'] as int,
      image: map['image'] as String,
      name: map['name'] as String,
      userId: map['userId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'crewId': crewId,
      'image': image,
      'name': name,
      'userId': userId,
    };
  }

  MemberModel copyWith({
    int? id,
    int? crewId,
    String? image,
    String? name,
    int? userId,
  }) {
    return MemberModel(
      id: id ?? this.id,
      crewId: crewId ?? this.crewId,
      image: image ?? this.image,
      name: name ?? this.name,
      userId: userId ?? this.userId,
    );
  }
}
