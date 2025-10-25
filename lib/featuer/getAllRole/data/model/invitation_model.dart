class InvitationModel {
  final String name;
  final String email;
  final String role;

  InvitationModel({
    required this.name,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
}