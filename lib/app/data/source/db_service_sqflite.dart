// import 'dart:async';

// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class LocalDatabaseService {
//   // 1. Private static instance variable
//   static LocalDatabaseService? _instance;

//   // 2. Private internal constructor
//   LocalDatabaseService._internal();

//   // 3. Public factory constructor
//   // This is the way to access the single instance
//   factory LocalDatabaseService() {
//     _instance ??= LocalDatabaseService._internal(); // Initialize if null
//     return _instance!;
//   }

//   // 4. Database instance variable (nullable)
//   static Database? _database;

//   // 5. Asynchronous getter for the database instance
//   Future<Database> get database async {
//     if (_database != null)
//       return _database!; // Return existing instance if available

//     // If _database is null, initialize it
//     _database = await _initDatabase();
//     return _database!;
//   }

//   // 6. Private method to initialize the database
//   Future<Database> _initDatabase() async {
//     // Get the directory path for both Android and iOS to store database.
//     String databasesPath = await getDatabasesPath();
//     String path =
//         join(databasesPath, 'medicine_app.db'); // Name your database file

//     // Open the database.
//     // The `onCreate` callback runs only the first time the database is created.
//     return await openDatabase(
//       path,
//       version: 1, // Increment version when you change the schema
//       onCreate: _onCreate,
//       // You can also add onUpgrade, onDowngrade callbacks if needed
//     );
//   }

//   // 7. Method to create tables (runs only during initial database creation)
//   Future<void> _onCreate(Database db, int version) async {
//     // Example: Create a 'medicines' table
//     // Adjust the SQL query based on your actual needs
//     await db.execute('''
//       CREATE TABLE medicines (
//         id TEXT PRIMARY KEY NOT NULL,       -- Corresponds to MedicineModel.id
//         medicineName TEXT NOT NULL,         -- Corresponds to MedicineModel.medicineName
//         dosage INTEGER NOT NULL,            -- Corresponds to MedicineModel.dosage
//         dosageUnit TEXT NOT NULL,           -- Corresponds to MedicineModel.dosageUnit
//         availableQuantity INTEGER NOT NULL, -- Corresponds to MedicineModel.availableQuantity
//         mealTiming TEXT NOT NULL,           -- Corresponds to MedicineModel.mealTiming
//         repeatSchedule TEXT NOT NULL,       -- Store JSON string for MedicineModel.repeatSchedule
//         scheduleTimes TEXT NOT NULL,        -- Store JSON string for MedicineModel.scheduleTimes
//         startDate INTEGER NOT NULL,         -- Store millisecondsSinceEpoch for MedicineModel.startDate
//         endDate INTEGER,                    -- Store millisecondsSinceEpoch? for MedicineModel.endDate (nullable)
//         imagePath TEXT,                     -- Corresponds to MedicineModel.imagePath (nullable)
//         createdAt INTEGER NOT NULL,         -- Store millisecondsSinceEpoch for MedicineModel.createdAt
//         modifiedAt INTEGER NOT NULL         -- Store millisecondsSinceEpoch for MedicineModel.modifiedAt
//       )
//     ''');
//     // Add other table creation statements here if needed
//     print("Database table 'medicines' created!");
//   }
// }
