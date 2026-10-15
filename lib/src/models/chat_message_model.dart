import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime? sentAt;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    this.sentAt,
  });

  factory ChatMessageModel.fromFirestore(String id, Map<String, dynamic> data) {
    final sent = data['sentAt'];
    return ChatMessageModel(
      id: id,
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? '',
      text: data['text'] as String? ?? '',
      // sentAt es null un instante mientras el servidor asigna la marca de tiempo
      sentAt: sent is Timestamp ? sent.toDate() : null,
    );
  }
}
