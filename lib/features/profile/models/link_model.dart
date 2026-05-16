class LinkModel {
  String? id;
  String? name;
  String? link;
  String? user_id;

  LinkModel({this.id, this.name, this.link, this.user_id});

  LinkModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name'];
    link = json['link'];
    user_id = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = name;
    json['link'] = link;
    json['user_id'] = user_id;
    return json;
  }
}