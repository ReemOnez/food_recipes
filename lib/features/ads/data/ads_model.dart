class AdModel {
  final String title;
  final String? image;
  final num number, id;

  AdModel({required this.id, required this.number, required this.title, required this.image});

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(id: json['id'], number: 0, title: json['category'], image: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {'id': id, 'number': number, 'title': title, 'image': image},
    };
  }
}