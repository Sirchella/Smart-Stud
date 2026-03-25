package export

import model.StudentResult
import org.apache.poi.ss.usermodel.FillPatternType
import org.apache.poi.ss.usermodel.IndexedColors
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import java.io.FileOutputStream

/**
 * Excel export implementation generating .xlsx files using Apache POI.
 */
class ExcelExporter : ExportStrategy {

    override fun export(results: List<StudentResult>, outputPath: String) {
        val workbook = XSSFWorkbook()
        val sheet = workbook.createSheet("Student Results")

        // Create header style: Bold & Yellow Background
        val headerStyle = workbook.createCellStyle()
        val font = workbook.createFont()
        font.bold = true
        headerStyle.setFont(font)
        headerStyle.fillForegroundColor = IndexedColors.YELLOW.index
        headerStyle.fillPattern = FillPatternType.SOLID_FOREGROUND

        val headers = listOf("Student Name", "CA Mark", "Exam Mark", "Total Score", "Grade", "Remark", "Pass/Fail")
        val headerRow = sheet.createRow(0)
        
        headers.forEachIndexed { index, title ->
            val cell = headerRow.createCell(index)
            cell.setCellValue(title)
            cell.cellStyle = headerStyle
        }

        // Fill table rows
        results.forEachIndexed { index, result ->
            val row = sheet.createRow(index + 1)
            row.createCell(0).setCellValue(result.name)
            row.createCell(1).setCellValue(result.caMark.toDouble())
            row.createCell(2).setCellValue(result.examMark.toDouble())
            row.createCell(3).setCellValue(result.total.toDouble())
            row.createCell(4).setCellValue(result.grade)
            row.createCell(5).setCellValue(result.remark)
            row.createCell(6).setCellValue(if (result.passed) "PASS" else "FAIL")
        }

        // Auto-size columns for better visibility
        headers.indices.forEach { sheet.autoSizeColumn(it) }

        FileOutputStream(outputPath).use { out ->
            workbook.write(out)
        }
        workbook.close()
    }
}
