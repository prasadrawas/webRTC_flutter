class Message {
  Message({
    this.sentFrom,
    this.message,
    this.token,
  });

  int? sentFrom;
  String? message;
  String? token;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sentFrom: json["sentFrom"],
        message: json["message"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "sentFrom": sentFrom,
        "message": message,
        "token": token,
      };
}
