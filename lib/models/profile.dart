class UserProfile {
  const UserProfile({
    required this.name,
    required this.bio,
    required this.avatarColorValue,
    required this.avatarPath,
    required this.dateOfBirth,
    required this.gongyoWeeklyGoal,
  });

  final String? name;
  final String? bio;
  final int? avatarColorValue;
  final String? avatarPath;
  final String? dateOfBirth;
  final int gongyoWeeklyGoal;

  UserProfile copyWith({
    String? name,
    String? bio,
    int? avatarColorValue,
    String? avatarPath,
    String? dateOfBirth,
    int? gongyoWeeklyGoal,
  }) {
    return UserProfile(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarColorValue: avatarColorValue ?? this.avatarColorValue,
      avatarPath: avatarPath ?? this.avatarPath,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gongyoWeeklyGoal: gongyoWeeklyGoal ?? this.gongyoWeeklyGoal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'avatarColorValue': avatarColorValue,
      'avatarPath': avatarPath,
      'dateOfBirth': dateOfBirth,
      'gongyoWeeklyGoal': gongyoWeeklyGoal,
    };
  }

  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      avatarColorValue: json['avatarColorValue'] as int?,
      avatarPath: json['avatarPath'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gongyoWeeklyGoal: (json['gongyoWeeklyGoal'] as num?)?.toInt() ?? 5,
    );
  }
}
