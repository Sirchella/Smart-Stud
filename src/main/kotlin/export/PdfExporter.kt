package export

import com.itextpdf.text.*
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.pdf.PdfPTable
import com.itextpdf.text.pdf.PdfWriter
import model.StudentResult
import java.io.FileOutputStream

/**
 * PDF export implementation using iText library.
 */
class PdfExporter : ExportStrategy {

    override fun export(results: List<StudentResult>, outputPath: String) {
        val document = Document()
        PdfWriter.getInstance(document, FileOutputStream(outputPath))

        document.open()

        // Add Title
        val titleFont = Font(Font.FontFamily.HELVETICA, 18f, Font.BOLD)
        val title = Paragraph("Student Grade Report", titleFont)
        title.alignment = Element.ALIGN_CENTER
        title.spacingAfter = 20f
        document.add(title)

        // Create Table
        val table = PdfPTable(7) // 7 columns
        table.widthPercentage = 100f
        table.setWidths(floatArrayOf(3f, 1f, 1f, 1.5f, 1f, 2f, 1.5f))

        // Headers
        val headers = listOf("Name", "CA", "Exam", "Total", "Grade", "Remark", "Status")
        val headerFont = Font(Font.FontFamily.HELVETICA, 12f, Font.BOLD)

        headers.forEach { headerTitle ->
            val cell = PdfPCell(Phrase(headerTitle, headerFont))
            cell.horizontalAlignment = Element.ALIGN_CENTER
            cell.backgroundColor = BaseColor.LIGHT_GRAY
            table.addCell(cell)
        }

        // Data Rows
        val dataFont = Font(Font.FontFamily.HELVETICA, 11f, Font.NORMAL)
        var passCount = 0
        var failCount = 0

        results.forEach { result ->
            table.addCell(PdfPCell(Phrase(result.name, dataFont)))
            
            val caCell = PdfPCell(Phrase(result.caMark.toString(), dataFont))
            caCell.horizontalAlignment = Element.ALIGN_CENTER
            table.addCell(caCell)
            
            val examCell = PdfPCell(Phrase(result.examMark.toString(), dataFont))
            examCell.horizontalAlignment = Element.ALIGN_CENTER
            table.addCell(examCell)
            
            val totalCell = PdfPCell(Phrase(result.total.toString(), dataFont))
            totalCell.horizontalAlignment = Element.ALIGN_CENTER
            table.addCell(totalCell)
            
            val gradeCell = PdfPCell(Phrase(result.grade, dataFont))
            gradeCell.horizontalAlignment = Element.ALIGN_CENTER
            table.addCell(gradeCell)
            
            table.addCell(PdfPCell(Phrase(result.remark, dataFont)))
            
            val status = if (result.passed) "PASS" else "FAIL"
            if (result.passed) passCount++ else failCount++
            
            val statusCell = PdfPCell(Phrase(status, dataFont))
            statusCell.horizontalAlignment = Element.ALIGN_CENTER
            table.addCell(statusCell)
        }

        document.add(table)

        // Footer Summary
        val summaryStr = "\nTotal Students: ${results.size} | Passed: $passCount | Failed: $failCount"
        val summary = Paragraph(summaryStr, Font(Font.FontFamily.HELVETICA, 12f, Font.BOLD))
        summary.spacingBefore = 10f
        document.add(summary)

        document.close()
    }
}
