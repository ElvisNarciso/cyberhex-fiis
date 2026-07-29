import 'package:flutter/material.dart';
import '../models/fii_asset.dart';
import '../models/fii_transaction.dart';
import '../database/db_helper.dart';

class PortfolioProvider with ChangeNotifier {
  List<FiiAsset> _assets = [];
  List<FiiAsset> get assets => _assets;

  Future<void> loadAssets() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('assets');
    _assets = maps.map((e) => FiiAsset.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addTransaction(FiiTransaction transaction) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('transactions', transaction.toMap());
    
    final result = await db.query('assets', where: 'ticker = ?', whereArgs: [transaction.ticker]);
    
    if (result.isEmpty) {
      if (transaction.type == 'buy') {
        final newAsset = FiiAsset(
          ticker: transaction.ticker,
          quantity: transaction.quantity,
          averagePrice: transaction.price,
        );
        await db.insert('assets', newAsset.toMap());
      }
    } else {
      final existingAsset = FiiAsset.fromMap(result.first);
      int newQty = existingAsset.quantity;
      double newAvgPrice = existingAsset.averagePrice;
      
      if (transaction.type == 'buy') {
        double totalValue = (existingAsset.quantity * existingAsset.averagePrice) + (transaction.quantity * transaction.price);
        newQty += transaction.quantity;
        newAvgPrice = totalValue / newQty;
      } else {
        newQty -= transaction.quantity;
      }
      
      if (newQty <= 0) {
        await db.delete('assets', where: 'ticker = ?', whereArgs: [transaction.ticker]);
      } else {
        await db.update('assets', {
          'quantity': newQty,
          'averagePrice': newAvgPrice
        }, where: 'ticker = ?', whereArgs: [transaction.ticker]);
      }
    }
    
    await loadAssets();
  }
}
