class User {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final String? image;
  final String? address;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.image,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String fullName = '${json['firstName']} ${json['lastName']}';

    String? address;
    if (json['address'] != null) {
      address =
          '${json['address']['address']}, ${json['address']['city']}, ${json['address']['state']}';
    }

    return User(
      id: json['id'],
      fullName: fullName,
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      address: address,
    );
  }
}
