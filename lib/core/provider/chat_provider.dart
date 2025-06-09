import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/core/services/gemini_service.dart';
import 'package:frogames_gpt_app/features/chat/data/chat_message.dart';
import 'package:logger/web.dart';

class ChatProvider extends ChangeNotifier {
  final Logger logger = Logger();
  final GeminiService geminiService = GeminiService();

  bool _isSending = false;
  bool get isSending => _isSending;

  bool _isLoadResponse = false;
  bool get isLoadResponse => _isLoadResponse;

  List<ChatMessage>? _messages;
  List<ChatMessage>? get messages => _messages;

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  void sendNewMessage() async {
    if (_isSending) return;

    _isSending = true;
    notifyListeners();

    try {
      final message = ChatMessage(
        chatId: 0,
        role: 'USER',
        content: messageController.text.trim(),
        timestamp: DateTime.now(),
      );

      await _saveMessage(message);
      _sendMessageToGemini(messageController.text.trim());

      messageController.clear();
    } catch (e) {
      logger.e('Error to send message in chat: $e');
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> _saveMessage(ChatMessage message) async {
    //  Save in database
    _addMessageToUI(message);
  }

  void _addMessageToUI(ChatMessage message) {
    _messages ??= [];
    _messages!.add(message);
    _scrollToBottom();
    notifyListeners();
  }

  void _sendMessageToGemini(String message) async {
    try {
      _isLoadResponse = true;

      final timestamp = DateTime.now();
      String response = '';

      final responseMessage = ChatMessage(
        id: timestamp.microsecondsSinceEpoch,
        chatId: 0,
        role: 'GEMINI',
        content: response,
        timestamp: timestamp,
      );

      _updateMessageToUI(responseMessage);

      geminiService
          .sendRequestStreamToModel(message)
          .listen(
            (value) {
              response += value;

              final updateMessage = responseMessage.copyWith(content: response);
              _updateMessageToUI(updateMessage);
              _isLoadResponse = false;
            },
            onDone: () {
              _isLoadResponse = false;
            },
            onError: (e) {
              logger.e('Error in Gemini Stream: $e');
              _isLoadResponse = false;
            },
          );
    } catch (e) {
      _isLoadResponse = false;
      logger.e('Error sending message to Gemini: $e');
    }
  }

  void _updateMessageToUI(ChatMessage responseMessage) {
    final index = _messages!.indexWhere(
      (message) => message.id == responseMessage.id,
    );

    if (index != -1) {
      _messages![index] = responseMessage;
      _scrollToBottom();
      notifyListeners();
    } else {
      _addMessageToUI(responseMessage);
    }
  }

  void _scrollToBottom() async {
    Future.delayed(Duration(microseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(microseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
