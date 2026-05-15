class ProjectModel {
  String? id;
  String? name;
  String? link;
  String? image;
  String? description;
  String? user_id;

  ProjectModel({
    this.id,
    this.name,
    this.link,
    this.image,
    this.description,
    this.user_id,
  });

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    link = json['link'];
    image = json['image'];
    description = json['description'];
    user_id = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = name;
    json['link'] = link;
    json['image'] = image;
    json['description'] = description;
    json['user_id'] = user_id;
    return json;
  }
}
