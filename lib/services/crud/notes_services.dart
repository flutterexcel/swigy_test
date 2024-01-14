import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:new_flutter/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class NotesService {
  Database? _db;
  NotesService._sharedInstance();
  static final NotesService _shared = NotesService._sharedInstance();
  List<DataBaseNotes> _notes = [];
  final _notesStreamController =
      StreamController<List<DataBaseNotes>>.broadcast();

  Stream<List<DataBaseNotes>> get allNotes => _notesStreamController.stream;

  Future<DataBaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DataBaseNotes> updateNote({
    required DataBaseNotes note,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getdatabaseOrThrow();

    await getNote(id: note.id);
    final updateCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<Iterable<DataBaseNotes>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getdatabaseOrThrow();
    final notes = await db.query(
      noteTable,
    );

    return notes.map((noteRow) => DataBaseNotes.fromRow(noteRow));
  }

  Future<DataBaseNotes> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getdatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ? ',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DataBaseNotes.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getdatabaseOrThrow();
    int count = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);

    return count;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getdatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DataBaseNotes> createNote({required DataBaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getdatabaseOrThrow();

    // make sure owner exists in thr databse with correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    } else {}

    const text = "";
    final noteId = await db.insert(noteTable,
        {userIdcolumn: owner.id, textColumn: text, isSyncedWithCloudColumn: 1});

    final note = DataBaseNotes(
      id: noteId,
      text: text,
      userId: owner.id,
      isSyncedWithCloud: true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<DataBaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getdatabaseOrThrow();
    final result =
        await db.query(userTable, limit: 1, where: 'email=?', whereArgs: [
      email.toLowerCase(),
    ]);
    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DataBaseUser.fromRow(result.first);
    }
  }

  Future<DataBaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getdatabaseOrThrow();
    final result =
        await db.query(userTable, limit: 1, where: 'email=?', whereArgs: [
      email.toLowerCase(),
    ]);

    if (result.isNotEmpty) {
      throw UserAlreadyExists;
    }
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DataBaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getdatabaseOrThrow();
    final deletedCount = db.delete(userTable,
        where: 'email =? ', whereArgs: [email.toLowerCase()]);
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getdatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNotesTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException catch (e) {}
  }
}

@immutable
class DataBaseUser {
  final int id;
  final String email;
  const DataBaseUser({
    required this.id,
    required this.email,
  });

  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() {
    return 'Person , ID =$id , email =$email';
  }

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DataBaseNotes {
  final String text;
  final int id;
  final int userId;
  final bool isSyncedWithCloud;

  DataBaseNotes({
    required this.id,
    required this.text,
    required this.userId,
    required this.isSyncedWithCloud,
  });

  DataBaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdcolumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            map[isSyncedWithCloudColumn] as int == 1 ? true : false;

  @override
  String toString() =>
      'Note , ID= $id userId = $userId , isSyncedWithCloud$isSyncedWithCloud';

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const idColumn = 'id';
const emailColumn = 'email';
const userIdcolumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const dbName = ' notes.db';
const noteTable = 'note';
const userTable = 'user';
// create the user table
const createUserTable = ''' 
       CREATE TABLE IF NOT EXISTS "user"  (
	"id"	INTEGER NOT NULL COLLATE UTF16CI,
	"email"	TEXT NOT NULL UNIQUE,
	"Field3"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
);
       ''';
// create the  notes table
const createNotesTable = ''' 
CREATE TABLE IF NOT EXISTS "notes" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL COLLATE UTF16CI,
	"text"	INTEGER,
	"is_synced_with_cloud"	INTEGER DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);
''';
