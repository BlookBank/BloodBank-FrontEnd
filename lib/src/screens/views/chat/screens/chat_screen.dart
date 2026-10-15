import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/blood_request_model.dart';
import '../../../../models/chat_message_model.dart';
import '../../../../services/chat_service.dart';
import '../../components/widgets/custom_appbar.dart';

/// Chat en tiempo real de una solicitud de sangre (mensajes guardados en
/// Firestore; la solicitud viene del back).
/// Chat en tiempo real de una solicitud de sangre. Los mensajes viven en Firestore (requestChats/{id}/messages);
/// es un hilo por solicitud, visible para todos los usuarios con sesión.
class ChatScreen extends StatefulWidget {
  /// Solicitud a la que pertenece el chat.
  final BloodRequestModel request;

  const ChatScreen({super.key, required this.request});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

/// Estado del chat: texto escrito, scroll y bandera de envio.
class _ChatScreenState extends State<ChatScreen> {
  /// Servicio que lee y envía los mensajes en Firestore.
  final ChatService _chatService = ChatService();
  /// Controlador del campo donde se escribe el mensaje.
  final TextEditingController _messageController = TextEditingController();
  /// Permite bajar la lista hasta el último mensaje.
  final ScrollController _scrollController = ScrollController();

  /// true mientras se envía un mensaje (evita enviarlo dos veces).
  bool _isSending = false;

  /// Libera los controladores al cerrar la pantalla.
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Envía el mensaje escrito y limpia el campo; si falla, muestra el error.
  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      await _chatService.sendMessage(widget.request.id, text);
      _messageController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Could not send the message: $e"),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  /// Baja la lista hasta el último mensaje después de dibujar.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Dibuja la lista de mensajes y la barra para escribir.
  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: CustomAppBar(
        titlee: "Chat - ${widget.request.patientName}",
        actionTrue: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessageModel>>(
              // StreamBuilder: se redibuja solo cada vez que llega un mensaje nuevo, sin recargar nada.
              stream: _chatService.watchMessages(widget.request.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(twentyPixelWidth(context)),
                      child: Text(
                        "Could not load messages: ${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColor.redColor),
                  );
                }

                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages yet. Say hello!",
                      style: TextStyle(fontFamily: 'Poppins', color: AppColor.textAss),
                    ),
                  );
                }

                _scrollToBottom();
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(twentyPixelWidth(context) * .6),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _MessageBubble(
                      message: message,
                      isMine: message.senderId == myUid,
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: twentyPixelWidth(context) * .6,
                vertical: twentyPixelHeight(context) * .4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: "Write a message",
                        filled: true,
                        fillColor: AppColor.textLight,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppColor.redColor),
                    onPressed: _isSending ? null : _send,
                    icon: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Burbuja de un mensaje: roja y a la derecha si es mio, gris y a la izquierda si es de otra persona.
class _MessageBubble extends StatelessWidget {
  /// Mensaje que se dibuja.
  final ChatMessageModel message;
  /// true si lo envio el usuario con sesión iniciada.
  final bool isMine;

  const _MessageBubble({required this.message, required this.isMine});

  /// Dibuja la burbuja con el nombre del remitente (solo en mensajes ajenos) y el texto.
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColor.redColor : AppColor.textLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMine)
              Text(
                message.senderName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColor.redColor,
                  fontFamily: 'Poppins',
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                color: isMine ? AppColor.whiteColor : AppColor.blackColor,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
