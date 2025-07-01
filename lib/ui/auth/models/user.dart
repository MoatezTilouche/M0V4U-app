class TMDBUser {
  final int id;
  final String username;
  final String? name;

  TMDBUser({
    required this.id,
    required this.username,
    this.name,
  });

  factory TMDBUser.fromJson(Map<String, dynamic> json) {
    return TMDBUser(
      id: json['id'],
      username: json['username'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,

    };
  }
}
