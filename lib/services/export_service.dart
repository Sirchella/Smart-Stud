import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  Future<void> exportCSV(List<Map<String, dynamic>> sessions) async {
    List<List<dynamic>> rows = [];
    
    // Header
    rows.add(["Date", "Duration", "Average Score", "Alerts", "Noise (Avg)", "Light (Avg)"]);
    
    // Data
    for (var session in sessions) {
      rows.add([
        session['date'],
        session['duration'],
        session['score'],
        session['alerts'],
        session['noise'],
        session['light'],
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/ssem_report_${DateTime.now().millisecondsSinceEpoch}.csv');
    
    await file.writeAsString(csvData);
    await Share.shareXFiles([XFile(file.path)], text: 'SSEM Study Report (CSV)');
  }

  Future<void> exportJSON(List<Map<String, dynamic>> sessions) async {
    String jsonData = jsonEncode(sessions);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/ssem_data_${DateTime.now().millisecondsSinceEpoch}.json');
    
    await file.writeAsString(jsonData);
    await Share.shareXFiles([XFile(file.path)], text: 'SSEM Raw Data (JSON)');
  }
}
