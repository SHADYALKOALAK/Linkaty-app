class UserModel {
  String? id;
  String? fullName;
  String? email;
  String? image;
  String? bio;
  String? typeOfJop;
  String? location;
  String? specialization;
  bool? is_profile_active;

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.image,
    this.bio,
    this.typeOfJop,
    this.location,
    this.specialization,
    this.is_profile_active = false,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    bio = json['bio'];
    typeOfJop = json['typeOfJop'];
    location = json['location'];
    specialization = json['specialization'];
    is_profile_active = json['is_profile_active'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['fullName'] = fullName;
    json['email'] = email;
    json['image'] = image;
    json['bio'] = bio;
    json['typeOfJop'] = typeOfJop;
    json['location'] = location;
    json['specialization'] = specialization;
    json['is_profile_active'] = is_profile_active;
    return json;
  }
}
