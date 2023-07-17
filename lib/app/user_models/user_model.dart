class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final String gender;
  final String country;
  final String dob;
  final double lat;
  final double long;
  final String? token;
  final bool? isLive;
  final int level;
  final String language;
  final String cover;
  final int balance;
  final int mychatprice;
  final String lastSeen;
  final String dateTime;

  UserModel({
    required this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.image = '',
    this.gender = '',
    this.dob = '',
    this.country = "India",
    this.lat = 0.0,
    this.long = 0.0,
    this.token = '',
    this.isLive = false,
    this.level = 0,
    this.language = "English",
    this.cover = '',
    this.balance = 0,
    this.mychatprice = 0,
    this.lastSeen = "Online",
    this.dateTime = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? "",
      image: json['image'],
      gender: json['gender'] ?? "",
      dob: json['dob'],
      country: json['country'],
      lat: json['lat'],
      long: json['long'],
      token: json['token'],
      isLive: json['isLive'],
      level: json['level'],
      language: json['language'],
      cover: json['cover'],
      balance: json['balance'],
      mychatprice: json['mychatprice'],
      lastSeen: json['lastSeen'],
      dateTime: json['dateTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'image': image,
        'gender': gender,
        'dob': dob,
        'country': country,
        'lat': lat,
        'long': long,
        'token': token,
        'isLive': isLive,
        'level': level,
        'language': language,
        'cover': cover,
        'balance': balance,
        'mychatprice': mychatprice,
        'lastSeen': "Online",
        'dateTime': DateTime.now().toString(),
      };
}
