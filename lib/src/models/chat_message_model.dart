import 'package:cloud_firestore/cloud_firestore.dart';

/// Mensaje del chat de una solicitud (documento de Firestore).
class ChatMessageModel {
  final String id;
  /// UID de quien envio el mensaje.
  final String senderId;
  /// Nombre mostrado de quien envio el mensaje.
  final String senderName;
  /// Contenido del mensaje.
  final String text;
  /// Hora de envio; es null un instante mientras el servidor asigna la marca de tiempo.
  final DateTime? sentAt;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    this.sentAt,
  });

  /// Construye el mensaje desde un documento de Firestore.
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
