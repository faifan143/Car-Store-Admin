class MessageModel {
  late String senderId;
  late String senderEmail;
  late String text;
  late String ntpDateTime;
  late String postImage;
  late String messageId;

  MessageModel({
    required this.text,
    required this.ntpDateTime,
    required this.senderEmail,
    required this.senderId,
    required this.postImage,
    required this.messageId,
  });
  MessageModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    ntpDateTime = json['ntpDateTime'];
    senderEmail = json['senderEmail'];
    senderId = json['senderId'];
    postImage = json['postImage'];
    messageId = json['messageId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderEmail': senderEmail,
      'senderId': senderId,
      'ntpDateTime': ntpDateTime,
      'messageId': messageId,
      'postImage': postImage,
    };
  }
}
