import 'package:frogames_gpt_app/features/chat/data/chat.dart';
import 'package:frogames_gpt_app/features/chat/data/chat_message.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  static Database? _database;

  final String TABLE_CHAT_MESSAGE = 'chat_messages';
  final String TABLE_CHATS = 'chats';

  factory LocalDatabaseService() {
    return _instance;
  }

  LocalDatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chat_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chats(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $TABLE_CHAT_MESSAGE(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatId INTEGER,
        role TEXT,
        content TEXT,
        timestamp TEXT,
        FOREIGN KEY (chatId) REFERENCES chats (id)
      )
    ''');
  }

  //  Methods for Chats

  Future<int> insertChat(Chat chat) async {
    Database? db = await database;
    return await db.insert(TABLE_CHATS, chat.toMap());
  }

  Future<List<Chat>> getChats() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(TABLE_CHATS);
    return List.generate(maps.length, (i) {
      return Chat.fromMap(maps[i]);
    });
  }

  Future<void> deleteChat(int chatId) async {
    final db = await database;

    await db.delete(TABLE_CHATS, where: 'id = ?', whereArgs: [chatId]);
  }

  //  Methods for Messages

  Future<int> insertMessage(ChatMessage message) async {
    Database db = await database;
    return await db.insert(TABLE_CHAT_MESSAGE, message.toMap());
  }

  Future<List<ChatMessage>> getMessageForChat(int chatId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      TABLE_CHAT_MESSAGE,
      where: 'chatId = ?',
      whereArgs: [chatId],
    );
    return List.generate(maps.length, (i) {
      return ChatMessage.fromMap(maps[i]);
    });
  }

  Future<void> deleteMessagesFromChat(int chatId) async {
    final db = await database;
    await db.delete(
      TABLE_CHAT_MESSAGE,
      where: 'chatId = ?',
      whereArgs: [chatId],
    );
  }

  Future<void> updateMessage(ChatMessage message) async {
    final db = await database;

    await db.update(
      TABLE_CHAT_MESSAGE,
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<bool> messageExist(int id) async {
    final db = await database;
    final result = await db.query(
      TABLE_CHAT_MESSAGE,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
