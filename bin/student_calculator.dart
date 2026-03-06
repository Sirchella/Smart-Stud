import 'dart:io';

import 'package:excel/excel.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

/// Data model class representing a student.
class Student {
  final String name;
  final int caMark; // 0–40
  final int examMark; // 0–60

  const Student(this.name, this.caMark, this.examMark);

  /// Total score out of 100.
  int calculateTotal() => caMark + examMark;

  /// Letter grade based on total score.
  ///
  /// 80–100 : A
  /// 70–79  : B
  /// 60–69  : C
  /// 50–59  : D
  /// 0–49   : F
  String calculateGrade() {
    final total = calculateTotal();
    if (total >= 80) return 'A';
    if (total >= 70) return 'B';
    if (total >= 60) return 'C';
    if (total >= 50) return 'D';
    return 'F';
  }

  /// Pass/fail determined from total score.
  bool isPassed() => calculateTotal() >= 50;

  /// Validates that CA and exam marks are within allowed ranges.
  /// Returns true if valid, false otherwise.
  bool validateMarks() {
    return caMark >= 0 && caMark <= 40 && examMark >= 0 && examMark <= 60;
  }

  /// Formats a detailed report string for the student.
  String formatReport() {
    final total = calculateTotal();
    final grade = calculateGrade();
    final status = isPassed() ? 'Pass' : 'Fail';
    return '$name: CA=$caMark, Exam=$examMark, Total=$total/100, Grade=$grade ($status)';
  }

  @override
  String toString() =>
      '$name -> Total: ${calculateTotal()} Grade: ${calculateGrade()}';
}

/// Higher-order function that processes each student with the provided action.
void processStudents(List<Student> students, void Function(Student) action) {
  for (final student in students) {
    action(student);
  }
}

void main() {
  // 1) In-memory demonstration of OOP + functional concepts.
  final students = <Student>[
    Student('Alice', 35, 50),
    Student('Bob', 20, 40),
    Student('Charlie', 30, 55),
    Student('Diana', 25, 45),
  ];

  stdout.writeln('=== Demonstration: OOP + Functional Programming ===\n');

  // Demonstrate function 1: Validation
  stdout.writeln('1. Validation function (validateMarks):');
  students.forEach((s) {
    final isValid = s.validateMarks();
    stdout.writeln('  ${s.name}: ${isValid ? "Valid" : "Invalid"} marks');
  });

  // Demonstrate function 2: Formatting
  stdout.writeln('\n2. Formatting function (formatReport):');
  students.forEach((s) => stdout.writeln('  ${s.formatReport()}'));

  // Demonstrate collection operation: filter
  stdout.writeln('\n3. Collection operation: filter (where) - Passed students:');
  final passedStudents = students.where((s) => s.isPassed()).toList();
  passedStudents.forEach((s) => stdout.writeln('  ${s.name} (${s.calculateGrade()})'));

  // Demonstrate collection operation: map
  stdout.writeln('\n4. Collection operation: map - Grade summaries:');
  final gradeSummaries =
      students.map((s) => '${s.name}: ${s.calculateGrade()}').toList();
  gradeSummaries.forEach((summary) => stdout.writeln('  $summary'));

  // Demonstrate higher-order function with lambda
  stdout.writeln('\n5. Custom higher-order function (processStudents) with lambda:');
  processStudents(
    students,
    (student) => stdout.writeln(
      '  ${student.name} -> Total: ${student.calculateTotal()}, Grade: ${student.calculateGrade()}',
    ),
  );

  // 2) Excel-based pipeline that uses the same Student model and functions.
  stdout.writeln('\n=== Excel-based grading (file I/O) ===');
  runExcelPipeline();
}

/// Reads students from `students_input.xlsx`, calculates grades,
/// prints them, and writes `students_grades.xlsx`.
void runExcelPipeline() {
  const inputFileName = 'students_input.xlsx';
  const outputFileName = 'students_grades.xlsx';

  try {
    final inputFile = File(inputFileName);

    if (!inputFile.existsSync()) {
      stderr.writeln('Error: "$inputFileName" not found in the current directory.');
      return;
    }

    final bytes = inputFile.readAsBytesSync();

    // Use spreadsheet_decoder for robust reading of the XLSX file.
    final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: false);
    if (decoder.tables.isEmpty) {
      stderr.writeln('Error: "$inputFileName" has no worksheets.');
      return;
    }

    // Use the first sheet in the workbook.
    final table = decoder.tables.values.first;

    // Create output workbook and use its default sheet.
    final outputExcel = Excel.createExcel();
    final defaultSheetName = outputExcel.getDefaultSheet();
    if (defaultSheetName == null) {
      stderr.writeln('Error: Failed to get default sheet for output workbook.');
      return;
    }
    final outputSheet = outputExcel[defaultSheetName];

    // Header row.
    outputSheet.appendRow([
      TextCellValue('Student Name'),
      TextCellValue('Total Score'),
      TextCellValue('Grade'),
      TextCellValue('Passed'),
    ]);

    stdout.writeln('Student Grades (from Excel)');
    stdout.writeln('-' * 40);

    // Assume row 0 is header in the input file; start from row 1.
    for (var rowIndex = 1; rowIndex < table.rows.length; rowIndex++) {
      final row = table.rows[rowIndex];

      if (row.isEmpty || row[0] == null) {
        // Skip empty or nameless rows.
        continue;
      }

      try {
        final name = row[0].toString();
        final caStr = row.length > 1 && row[1] != null ? row[1].toString() : '';
        final examStr = row.length > 2 && row[2] != null ? row[2].toString() : '';

        final ca = int.parse(caStr);
        final exam = int.parse(examStr);

        // Basic range validation.
        if (ca < 0 || ca > 40 || exam < 0 || exam > 60) {
          stderr.writeln(
            'Skipping "$name" on row ${rowIndex + 1}: marks out of allowed range '
            '(CA 0–40, Exam 0–60).',
          );
          continue;
        }

        final student = Student(name, ca, exam);

        stdout.writeln(
          '${student.name}: ${student.calculateTotal()}/100 '
          '-> ${student.calculateGrade()} '
          '(${student.isPassed() ? 'Pass' : 'Fail'})',
        );

        // Append to output sheet.
        outputSheet.appendRow([
          TextCellValue(student.name),
          IntCellValue(student.calculateTotal()),
          TextCellValue(student.calculateGrade()),
          TextCellValue(student.isPassed() ? 'Pass' : 'Fail'),
        ]);
      } on FormatException {
        stderr.writeln(
          'Skipping row ${rowIndex + 1}: CA or Exam mark is not a valid integer.',
        );
      } catch (e) {
        stderr.writeln(
          'Unexpected error processing row ${rowIndex + 1}: $e',
        );
      }
    }

    stdout.writeln('-' * 40);

    // Save the output Excel file.
    final encoded = outputExcel.encode();
    if (encoded == null) {
      stderr.writeln('Error: failed to encode output workbook.');
      return;
    }

    final outputFile = File(outputFileName);
    outputFile.writeAsBytesSync(encoded, flush: true);
    stdout.writeln('Grades saved to "$outputFileName".');
  } on FileSystemException catch (e) {
    stderr.writeln('File system error: ${e.message}');
  } catch (e) {
    stderr.writeln('Unexpected error: $e');
  }
}

