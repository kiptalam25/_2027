class UserModel {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String phone;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.bio,
      required this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'bio': bio, 'phone': phone};
  }
}
