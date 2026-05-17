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
  bool? isVerified;
  String? role;

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
    this.isVerified = false,
    this.role,
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
    isVerified = json['isVerified'];
    role = json['role'] ?? 'user';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'image': image,
      'bio': bio,
      'typeOfJop': typeOfJop,
      'location': location,
      'specialization': specialization,
      'is_profile_active': is_profile_active,
      'isVerified': isVerified,
      'role': role ?? 'user',
    };
  }
}