import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.bonuses,
    required this.referalCode,
  });

  factory User.fromJson(json) {
    return _$UserFromJson(json);
  }
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final int bonuses;
  final String referalCode;

  @override
  List<Object?> get props => [id];
}
