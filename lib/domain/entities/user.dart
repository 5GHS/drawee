import 'dart:convert';

class AppUser {
  final String id;
  final String name;
  final String profile;

  AppUser({
    required this.id,
    required this.name,
    required this.profile, required email,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? profile,
  }) =>
      AppUser(
        id: id ?? this.id,
        name: name ?? this.name,
        profile: profile ?? this.profile, email: null,
      );

  factory AppUser.fromRawJson(String str) => AppUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json["id"],
        name: json["name"],
        profile: json["profile"], email: null,
      );

  get email => null;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile": profile,
      };
}