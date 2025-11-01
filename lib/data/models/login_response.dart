class LoginResponse {
  final bool status;
  final String accessToken;
  final String refreshToken;
  final double expiresInSec;
  final UserModel user;

  LoginResponse({
    required this.status,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresInSec,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresInSec: (json['expires_in_sec'] ?? 0).toDouble(),
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in_sec': expiresInSec,
      'user': user.toJson(),
    };
  }
}

class UserModel {
  final int id;
  final String roleId;
  final String role;
  final String firstName;
  final String? lastName;
  final String profileImageUrl;

  UserModel({
    required this.id,
    required this.roleId,
    required this.role,
    required this.firstName,
    this.lastName,
    required this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      roleId: json['role_id'] ?? '',
      role: json['role'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      profileImageUrl: json['profile_image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_id': roleId,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'profile_image_url': profileImageUrl,
    };
  }
}
