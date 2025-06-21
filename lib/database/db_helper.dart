import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/customer.dart';
import '../models/billing_history.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('billing_system.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
     final appDocDir = await getApplicationDocumentsDirectory();
  final path = join(appDocDir.path, filePath);
    print('[DB] Database path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Products table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 0,
        buyingPrice REAL NOT NULL DEFAULT 0.0,
        sellingPrice REAL NOT NULL DEFAULT 0.0,
        isSelectedForBilling INTEGER NOT NULL DEFAULT 0,
        category TEXT,
        description TEXT,
        unit TEXT DEFAULT 'pcs',
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Customers table
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        contactNumber TEXT,
        email TEXT,
        address TEXT,
        gstNumber TEXT,
        remarks TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Billing history table
    await db.execute('''
      CREATE TABLE billing_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoiceNumber TEXT NOT NULL UNIQUE,
        date TEXT NOT NULL,
        totalAmount REAL NOT NULL DEFAULT 0.0,
        taxAmount REAL NOT NULL DEFAULT 0.0,
        discountAmount REAL NOT NULL DEFAULT 0.0,
        pdfPath TEXT,
        customerName TEXT,
        customerContact TEXT,
        customerAddress TEXT,
        remarks TEXT,
        engineType TEXT,
        pump TEXT,
        serialNumber TEXT UNIQUE,
        governor TEXT,
        feedPump TEXT,
        noozelHolder TEXT,
        vehicleNumber TEXT,
        mechanicName TEXT,
        arrivedDate TEXT,
        deliveredDate TEXT,
        billingDate TEXT,
        pumpLabourCharge REAL NOT NULL DEFAULT 0.0,
        nozzleLabourCharge REAL NOT NULL DEFAULT 0.0,
        otherCharges REAL NOT NULL DEFAULT 0.0
      )
    ''');

    // Billing items table
    await db.execute('''
      CREATE TABLE billing_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        billingHistoryId INTEGER NOT NULL,
        productName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unitPrice REAL NOT NULL,
        totalPrice REAL NOT NULL,
        unit TEXT DEFAULT 'pcs',
        FOREIGN KEY (billingHistoryId) REFERENCES billing_history (id) ON DELETE CASCADE
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future _insertSampleData(Database db) async {
    // Sample products based on the bill image
    final sampleProducts = [
      'ELEMENTS',
      'D VALVES',
      'NOZZLES',
      'WASHERS D',
      'CAM SHIMS',
      'OIL SEAL',
      'BASE CAPS',
      'P. GASKET',
      'AIRVENT SCREW',
      'DIAPHRAM',
      'HOUSING GASKET',
      'RUBBER RING',
      'BEARING 1900',
      'PISTON',
      'PR PIN',
      'GOV.KIT',
      'FEED PUMP KIT',
      'ROLLER KIT',
    ];

    for (String productName in sampleProducts) {
      await db.insert('products', {
        'name': productName,
        'quantity': 10,
        'buyingPrice': 100.0,
        'sellingPrice': 150.0,
        'isSelectedForBilling': 1,
        'category': 'Pump Parts',
        'unit': 'pcs',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  // Product CRUD operations
  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products', orderBy: 'name ASC');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getBillingProducts() async {
    final db = await instance.database;
    final result = await db.query(
      'products',
      where: 'isSelectedForBilling = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Customer CRUD operations
  Future<int> insertCustomer(Customer customer) async {
    final db = await instance.database;
    return await db.insert('customers', customer.toMap());
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.database;
    final result = await db.query('customers', orderBy: 'name ASC');
    return result.map((map) => Customer.fromMap(map)).toList();
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await instance.database;
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(int id) async {
    final db = await instance.database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // Billing history operations
  Future<int> insertBillingHistory(BillingHistory billing) async {
    final db = await instance.database;
    try {
      print('[DB] Inserting billing history: invoiceNumber=${billing.invoiceNumber}');
      final id = await db.insert('billing_history', billing.toMap());
      print('[DB] Inserted billing_history id: $id');
      // Insert billing items
      for (BillingItem item in billing.items) {
        print('[DB] Inserting billing item for billingHistoryId=$id, productName=${item.productName}');
        await db.insert('billing_items', item.copyWith(billingHistoryId: id).toMap());
      }
      return id;
    } catch (e) {
      print('[DB][ERROR] Failed to insert billing history: $e');
      rethrow;
    }
  }

  Future<List<BillingHistory>> getAllBillingHistory() async {
    final db = await instance.database;
    final result = await db.query('billing_history', orderBy: 'date DESC');
    
    List<BillingHistory> billings = [];
    for (Map<String, dynamic> map in result) {
      final billing = BillingHistory.fromMap(map);
      final items = await getBillingItems(billing.id!);
      billings.add(billing.copyWith(items: items));
    }
    
    return billings;
  }

  Future<List<BillingItem>> getBillingItems(int billingHistoryId) async {
    final db = await instance.database;
    final result = await db.query(
      'billing_items',
      where: 'billingHistoryId = ?',
      whereArgs: [billingHistoryId],
    );
    return result.map((map) => BillingItem.fromMap(map)).toList();
  }

  Future<String> generateInvoiceNumber() async {
    final db = await instance.database;
    final today = DateTime.now();
    final datePrefix = 'INV${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';

    // Find the max sequence for today
    final result = await db.rawQuery(
      "SELECT invoiceNumber FROM billing_history WHERE invoiceNumber LIKE '$datePrefix%' ORDER BY invoiceNumber DESC LIMIT 1"
    );

    int nextSeq = 1;
    if (result.isNotEmpty && result.first['invoiceNumber'] != null) {
      final lastInvoice = result.first['invoiceNumber'] as String;
      final seqStr = lastInvoice.substring(datePrefix.length);
      final lastSeq = int.tryParse(seqStr) ?? 0;
      nextSeq = lastSeq + 1;
      print('[DB] Last invoice for today: $lastInvoice, lastSeq: $lastSeq, nextSeq: $nextSeq');
    } else {
      print('[DB] No invoice found for today, starting with 1');
    }

    final invoiceNumber = '$datePrefix${nextSeq.toString().padLeft(3, '0')}';
    print('[DB] Generated invoice number: $invoiceNumber');
    return invoiceNumber;
  }

  Future<int> getNextSerialNumber() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT MAX(CAST(serialNumber AS INTEGER)) as maxSerial FROM billing_history');
    int nextSerial = 1;
    if (result.isNotEmpty && result.first['maxSerial'] != null) {
      final lastSerial = int.tryParse(result.first['maxSerial'].toString()) ?? 0;
      nextSerial = lastSerial + 1;
    }
    return nextSerial;
  }

  Future<List<Map<String, dynamic>>> debugGetAllBills() async {
    final db = await instance.database;
    return await db.query('billing_history', orderBy: 'id DESC');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

extension BillingItemExtension on BillingItem {
  BillingItem copyWith({
    int? id,
    int? billingHistoryId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? unit,
  }) {
    return BillingItem(
      id: id ?? this.id,
      billingHistoryId: billingHistoryId ?? this.billingHistoryId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      unit: unit ?? this.unit,
    );
  }
}

extension BillingHistoryExtension on BillingHistory {
  BillingHistory copyWith({
    int? id,
    String? invoiceNumber,
    DateTime? date,
    double? totalAmount,
    double? taxAmount,
    double? discountAmount,
    String? pdfPath,
    String? customerName,
    String? customerContact,
    String? customerAddress,
    String? remarks,
    List<BillingItem>? items,
  }) {
    return BillingHistory(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      pdfPath: pdfPath ?? this.pdfPath,
      customerName: customerName ?? this.customerName,
      customerContact: customerContact ?? this.customerContact,
      customerAddress: customerAddress ?? this.customerAddress,
      remarks: remarks ?? this.remarks,
      items: items ?? this.items,
    );
  }
}
