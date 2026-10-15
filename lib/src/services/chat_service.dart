import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_message_model.dart';

/// Mensajes por solicitud de sangre, en tiempo real con Firestore:
/// requestChats/{requestId}/messages/{messageId}
class ChatService {
  // Firestore entrega los mensajes en tiempo real con snapshots.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Coleccion de mensajes de una solicitud.
  CollectionReference<Map<String, dynamic>> _messages(int requestId) =>
      _firestore.collection('requestChats').doc('$requestId').collection('messages');

  /// Escucha los mensajes de una solicitud en tiempo real, ordenados por hora de envio.
  Stream<List<ChatMessageModel>> watchMessages(int requestId) {
    return _messages(requestId).orderBy('sentAt').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessageModel.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Envía un mensaje a nombre del usuario con sesión iniciada. Ignora mensajes vacios.
  Future<void> sendMessage(int requestId, String text) async {
    final user = FirebaseAuth.instance.currentUser;
    final trimmed = text.trim();
    if (user == null || trimmed.isEmpty) return;

    await _messages(requestId).add({
      'senderId': user.uid,
      'senderName': user.displayName ?? user.email ?? 'User',
      'text': trimmed,
      // La hora la pone el servidor de Firestore, para que todos vean el mismo orden.
      'sentAt': FieldValue.serverTimestamp(),
    });
  }
}
