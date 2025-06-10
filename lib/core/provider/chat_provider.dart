import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/core/services/gemini_service.dart';
import 'package:frogames_gpt_app/core/services/local_database_service.dart';
import 'package:frogames_gpt_app/features/chat/data/chat.dart';
import 'package:frogames_gpt_app/features/chat/data/chat_message.dart';
import 'package:logger/web.dart';

class ChatProvider extends ChangeNotifier {
  final Logger logger = Logger();
  final GeminiService geminiService = GeminiService();
  final LocalDatabaseService dbService = LocalDatabaseService();

  bool _isSending = false;
  bool get isSending => _isSending;

  bool _isLoadResponse = false;
  bool get isLoadResponse => _isLoadResponse;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<ChatMessage>? _messages;
  List<ChatMessage>? get messages => _messages;

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  Chat? _activeChat;
  Chat? get activeChat => _activeChat;

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setActiveChat(Chat chat) {
    _activeChat = chat;
    getMessageFromChat(chat.id!);
    notifyListeners();
  }

  Future<void> insertChat() async {
    try {
      final chatId = DateTime.now().microsecondsSinceEpoch;
      final chat = Chat(
        id: chatId,
        name: messageController.text.trim(),
        createdAt: DateTime.now(),
      );

      final message = ChatMessage(
        chatId: chatId,
        role: 'USER',
        content: messageController.text.trim(),
        timestamp: DateTime.now(),
      );

      await _saveChatAndMessage(chat, message);
      _sendMessageToGemini(chatId, message.content.trim());

      setActiveChat(chat);
      messageController.clear();
      fetchChats();
    } catch (e) {
      logger.e('Error to insert new chat: $e');
    }
  }

  void sendNewMessage() async {
    if (_isSending) return;

    _isSending = true;
    notifyListeners();

    try {
      if (_activeChat == null) return;

      final message = ChatMessage(
        chatId: _activeChat!.id!,
        role: 'USER',
        content: messageController.text.trim(),
        timestamp: DateTime.now(),
      );

      await _saveMessage(message);
      _sendMessageToGemini(_activeChat!.id!, messageController.text.trim());

      messageController.clear();
    } catch (e) {
      logger.e('Error to send message in chat: $e');
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> _saveChatAndMessage(Chat chat, ChatMessage message) async {
    await dbService.insertChat(chat);
    await dbService.insertMessage(message);

    _addMessageToUI(message);
  }

  Future<void> _saveMessage(ChatMessage message) async {
    await dbService.insertMessage(message);
    _addMessageToUI(message);
  }

  void _addMessageToUI(ChatMessage message) {
    _messages ??= [];
    _messages!.add(message);
    _scrollToBottom();
    notifyListeners();
  }

  void _sendMessageToGemini(int chatId, String message) async {
    try {
      _isLoadResponse = true;

      final timestamp = DateTime.now();
      String response = '';

      final responseMessage = ChatMessage(
        id: timestamp.microsecondsSinceEpoch,
        chatId: chatId,
        role: 'GEMINI',
        content: response,
        timestamp: timestamp,
      );

      _updateMessageToUI(responseMessage);

      geminiService
          .sendRequestStreamToModel(message)
          .listen(
            (value) async {
              response += value;

              final updateMessage = responseMessage.copyWith(content: response);
              _updateMessageToUI(updateMessage);
              await updateOrInsertMessage(updateMessage);
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

  void fetchChats() async {
    _chats = await dbService.getChats();
    notifyListeners();
  }

  void getMessageFromChat(int chatId) async {
    final response = await dbService.getMessageForChat(chatId);
    _messages = response.isEmpty ? null : response;
    notifyListeners();
  }

  void deleteChat(Chat chat) async {
    if (chat == _activeChat) {
      _activeChat = null;
    }

    _chats.remove(chat);
    _messages?.removeWhere((message) => message.chatId == chat.id);
    notifyListeners();

    await dbService.deleteChat(chat.id!);
    await dbService.deleteMessagesFromChat(chat.id!);
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(microseconds: 300),
          curve: Curves.easeOut,
        );
        });
      }
    });
  }

  Future<void> updateOrInsertMessage(ChatMessage message) async {
    if (await dbService.messageExist(message.id!)) {
      dbService.updateMessage(message);
    } else {
      dbService.insertMessage(message);
    }
  }
}
