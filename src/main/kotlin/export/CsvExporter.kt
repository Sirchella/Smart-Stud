package export

import model.StudentResult
import java.io.File

/**
 * CSV export implementation using pure Kotlin constructs.
 */
class CsvExporter : ExportStrategy {

    override fun export(results: List<StudentResult>, outputPath: String) {
        val file = File(outputPath)
        
        file.bufferedWriter().use { writer ->
            writer.write("Student Name,CA Mark,Exam Mark,Total Score,Grade,Remark,Pass/Fail\n")
            
            results.forEach { result ->
                val status = if (result.passed) "PASS" else "FAIL"
                
                // Escape names with commas by quoting them
                val safeName = if (result.name.contains(",")) "\"${result.name}\"" else result.name
                
                writer.write("$safeName,${result.caMark},${result.examMark},${result.total},${result.grade},${result.remark},$status\n")
            }
        }
    }
}
