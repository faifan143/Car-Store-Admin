import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqflite {
  static Future<void> storeNotificationInCache(
      String title, String message) async {
    // Get the path for the SQLite database file
    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, 'notifications.db');

    // Open the database
    Database database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      // Create the notifications table
      await db.execute(
          'CREATE TABLE notifications (id INTEGER PRIMARY KEY, title TEXT, message TEXT)');
    });
    // Insert the notification into the database
    await database
        .insert('notifications', {'title': title, 'message': message});

    // Close the database
    await database.close();
  }

  static Future<List<Map<String, dynamic>>>
      getAllNotificationsFromCache() async {
    // Get the path for the SQLite database file
    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, 'notifications.db');

    // Open the database
    Database database = await openDatabase(dbPath);

    // Query all notifications from the database
    List<Map<String, dynamic>> notifications =
        await database.query('notifications');

    // Close the database
    await database.close();

    return notifications;
  }
}
