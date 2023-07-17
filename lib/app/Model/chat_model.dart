class ChatModel {
  String name;
  String avatarUrl;
  String id;
  bool isGroup;
  String lastMessage;
  String lastMessageTime;

  ChatModel({
    required this.name,
    required this.avatarUrl,
    required this.id,
    required this.isGroup,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  ChatModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        avatarUrl = json['avatarUrl'],
        id = json['id'],
        isGroup = json['isGroup'],
        lastMessageTime = json['lastMessageTime'],
        lastMessage = json['lastMessage'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatarUrl': avatarUrl,
        'id': id,
        'isGroup': isGroup,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime,
      };
}

enum MessageType {
  image,
  text,
  audio,
  video,
}

class MessageModel {
  String message;
  MessageType type;
  String time;
  String senderId;
  String receiverId;
  String senderName;
  String receiverName;
  String senderAvatar;
  String receiverAvatar;
  String id;
  bool isRead = false;
  String? imageUrl;
  String? audioUrl;
  String? videoUrl;

  MessageModel({
    required this.message,
    required this.type,
    required this.time,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    required this.senderAvatar,
    required this.receiverAvatar,
    required this.id,
    this.isRead = false,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        type = MessageType.values[json['type']],
        time = json['time'],
        senderId = json['senderId'],
        receiverId = json['receiverId'],
        senderName = json['senderName'],
        receiverName = json['receiverName'],
        senderAvatar = json['senderAvatar'],
        receiverAvatar = json['receiverAvatar'],
        id = json['id'],
        imageUrl = json['imageUrl'],
        audioUrl = json['audioUrl'],
        videoUrl = json['videoUrl'],
        isRead = json['isRead'];

  Map<String, dynamic> toJson() => {
        'message': message,
        'type': MessageType.values.indexOf(type),
        'time': time,
        'senderId': senderId,
        'receiverId': receiverId,
        'senderName': senderName,
        'receiverName': receiverName,
        'senderAvatar': senderAvatar,
        'receiverAvatar': receiverAvatar,
        'id': id,
        'isRead': isRead,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'videoUrl': videoUrl,
      };
}
