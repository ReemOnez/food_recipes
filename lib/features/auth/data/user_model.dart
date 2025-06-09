class UserModel {
  final String id, email, name, token;
  final String? image;

  UserModel({required this.id, required this.email, required this.name, required this.image, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email'], name: json['name'], image: json['image'], token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {'id': id, 'email': email, 'name': name, 'image': image, 'token': token},
    };
  }
}
