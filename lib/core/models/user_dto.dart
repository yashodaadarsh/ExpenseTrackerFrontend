class UserDto {
  final String userId;
  final String firstName;
  final String lastName;
  final int phoneNumber; // Java uses Long
  final String email;
  final String? profilePic;
  final int limit;

  UserDto({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.profilePic,
    required this.limit,
  });

  // Factory to create object from JSON (Backend -> App)
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['user_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? 0,
      email: json['email'] ?? '',
      profilePic: json['profile_pic'],
      limit: json['monthly_limit'] ?? 0,
    );
  }

  // Method to convert object to JSON (App -> Backend)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'profile_pic': profilePic,
      'monthly_limit': limit,
    };
  }
}