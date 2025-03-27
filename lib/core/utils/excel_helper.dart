import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ExcelHelper {
  static Future<void> updateTrigger({
    required String sheetName,
    required String cell,
    required bool triggerValue,
  }) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/HomeKitTrigger.xlsx';
      File file = File(filePath);

      Excel excel;

      if (await file.exists()) {
        var bytes = file.readAsBytesSync();
        excel = Excel.decodeBytes(bytes);
        debugPrint('Excel loaded from: $filePath');
      } else {
        excel = Excel.createExcel(); // Creates with 'Sheet1'
        debugPrint('New Excel file created at: $filePath');
      }

      // Always use the first available sheet
      final sheetKey = excel.sheets.keys.first;
      final value = triggerValue ? 'TRUE' : 'FALSE';

      debugPrint(
          '🔄 Writing to Excel → Sheet: $sheetKey | Cell: $cell | Value: $value');

      excel.updateCell(sheetKey, CellIndex.indexByString(cell), value);

      final excelBytes = excel.encode();
      if (excelBytes != null) {
        await file.writeAsBytes(excelBytes);
        debugPrint('Excel file updated at: $filePath');
      }
    } catch (e) {
      debugPrint('Error writing Excel: $e');
    }
  }
}
