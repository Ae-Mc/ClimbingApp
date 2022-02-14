import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  @JsonSerializable()
  factory User({
    required String id,
    required String username,
    required String firstName,
    required String lastName,
  }) = _;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
