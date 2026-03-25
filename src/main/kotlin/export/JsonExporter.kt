package export

import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import model.StudentResult
import java.io.File

/**
 * JSON export implementation using kotlinx-serialization.
 */
class JsonExporter : ExportStrategy {

    private val jsonFormatter = Json { prettyPrint = true }

    override fun export(results: List<StudentResult>, outputPath: String) {
        val file = File(outputPath)
        
        // We need to define a serializable DTO for export since StudentResult is not annotated here,
        // or we simply annotate StudentResult. By requirements, Student.kt holds them.
        // If we can't modify the data class with @Serializable, we can map to a local data class.
        // Let's create an inline data class for serialization.
        
        val serializableResults = results.map { SerializableResult(it.name, it.caMark, it.examMark, it.total, it.grade, it.passed, it.remark) }
        
        val jsonString = jsonFormatter.encodeToString(serializableResults)
        file.writeText(jsonString)
    }
    
    @kotlinx.serialization.Serializable
    private data class SerializableResult(
        val name: String,
        val caMark: Int,
        val examMark: Int,
        val total: Int,
        val grade: String,
        val passed: Boolean,
        val remark: String
    )
}
