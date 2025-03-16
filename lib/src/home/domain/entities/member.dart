import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final int id;
  final int crewId;
  final String image;
  final String name;
  final int userId;

  const Member({
    required this.id,
    required this.crewId,
    required this.image,
    required this.name,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, userId];
}
