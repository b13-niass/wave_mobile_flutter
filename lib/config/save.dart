// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('app_database.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//         await db.execute('''
//       CREATE TABLE frais (
//           id INTEGER PRIMARY KEY,
//           valeur REAL
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE pays (
//           id INTEGER PRIMARY KEY,
//           libelle TEXT,
//           indicatif TEXT
//       )
//     ''');
    
//     await db.execute('''
//       CREATE TABLE users (
//           id INTEGER PRIMARY KEY,
//           nom TEXT,
//           prenom TEXT,
//           adresse TEXT,
//           fileCni TEXT,
//           cni TEXT,
//           dateNaissance TEXT,
//           codeVerification TEXT,
//           telephone TEXT UNIQUE,
//           channel TEXT,
//           email TEXT UNIQUE,
//           password TEXT,
//           nbrConnection INTEGER DEFAULT 0,
//           etatCompte TEXT,
//           role TEXT,
//           pays_id INTEGER,
//           FOREIGN KEY (pays_id) REFERENCES pays (id)
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE favoris (
//           id INTEGER PRIMARY KEY,
//           nom TEXT,
//           prenom TEXT,
//           telephone TEXT,
//           user_id INTEGER,
//           FOREIGN KEY (user_id) REFERENCES users (id)
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE transactions (
//           id INTEGER PRIMARY KEY,
//           montantEnvoye REAL,
//           montantRecus REAL,
//           etatTransaction TEXT,
//           typeTransaction TEXT,
//           sender_id INTEGER,
//           receiver_id INTEGER,
//           frais_id INTEGER,
//           FOREIGN KEY (sender_id) REFERENCES users (id),
//           FOREIGN KEY (receiver_id) REFERENCES users (id),
//           FOREIGN KEY (frais_id) REFERENCES frais (id)
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE planifications (
//           id INTEGER PRIMARY KEY,
//           montantEnvoye REAL,
//           montantRecus REAL,
//           periode TEXT,
//           sender_id INTEGER,
//           receiver_id INTEGER,
//           FOREIGN KEY (sender_id) REFERENCES users (id),
//           FOREIGN KEY (receiver_id) REFERENCES users (id)
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE wallets (
//           id INTEGER PRIMARY KEY,
//           solde REAL,
//           plafond REAL,
//           user_id INTEGER UNIQUE,
//           FOREIGN KEY (user_id) REFERENCES users (id)
//       )
//     ''');
//   }

//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }
