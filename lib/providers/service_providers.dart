import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/export_service.dart';
import '../services/pdf_service.dart';

final exportServiceProvider = Provider((ref) => ExportService());
final pdfServiceProvider = Provider((ref) => PDFService());
