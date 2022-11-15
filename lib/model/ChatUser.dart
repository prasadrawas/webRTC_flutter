class ChatUser {
  ChatUser({
    this.name,
    this.email,
    this.token,
    this.ref,
  });

  String? name;
  String? email;
  String? token;
  String? ref;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        name: json["name"],
        email: json["email"],
        token: json["token"],
        ref: json["ref"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "token": token,
        "ref": ref,
      };
}
