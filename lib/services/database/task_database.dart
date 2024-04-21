import 'package:notes_goonline/const/database_const.dart';
import 'package:notes_goonline/models/task_model.dart';
import 'package:notes_goonline/services/database/database_exceptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TaskDatabase {
  static final TaskDatabase _instance = TaskDatabase._internal();
  TaskDatabase._internal();
  factory TaskDatabase() => _instance;
  Database? _database;

  Database get database {
    final db = _database;
    if (db == null) {
      throw DatabaseNotFoundException();
    }
    return db;
  }

  Future<void> _openDb() async {
    if (_database == null) {
      try {
        final appDocsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(appDocsPath.path, dbName);
        final db = await openDatabase(dbPath);
        _database = db;
        await db.execute(createTable);
      } on MissingPlatformDirectoryException {
        throw UnableToGetDocumentsDirectoryException();
      } catch (e) {
        throw UnknownDatabaseException();
      }
    }
  }

  Future<void> _ensureDbIsOpen() async {
    final db = _database;
    if (db == null) {
      await _openDb();
    }
  }

  Future<List<Map<String, Object?>>> getTasks() async {
    await _ensureDbIsOpen();
    final tasks = await database.query(
      taskTableName,
    );
    return tasks;
  }

  Future<void> addTask(Task task) async {
    await _ensureDbIsOpen();
    await database.insert(taskTableName, {
      idColumn: task.id,
      nameColumn: task.name,
      descriptionColumn: task.description,
      deadlineColumn: task.deadline,
      doneDateColumn: task.doneDate,
      priorityColumn: task.priority,
      ownerColumn: task.owner,
      statusColumn: task.status
    });
  }

  Future<void> updateTask(Task task) async {
    await _ensureDbIsOpen();

    final count = await database.update(
      taskTableName,
      {
        idColumn: task.id,
        nameColumn: task.name,
        descriptionColumn: task.description,
        deadlineColumn: task.deadline,
        doneDateColumn: task.doneDate,
        priorityColumn: task.priority,
        ownerColumn: task.owner,
        statusColumn: task.status
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );

    if (count == 0) {
      throw CouldNotUpdateDatabaseException;
    }
  }

  Future<void> deleteTask(Task task) async {
    await _ensureDbIsOpen();
    final count = await database.delete(
      taskTableName,
      where: 'id = ?',
      whereArgs: [task.id],
    );

    if (count == 0) {
      throw CouldNotDeleteDatabaseException;
    }
  }
}
