package export

import model.StudentResult

/**
 * Orchestrator responsible for invoking all available export strategies.
 */
object ExportManager {

    /**
     * Exports the results to Excel, CSV, PDF, and JSON formats using the provided base name.
     */
    fun exportAll(results: List<StudentResult>, baseOutputName: String) {
        val strategies = mapOf(
            "$baseOutputName.xlsx" to ExcelExporter(),
            "$baseOutputName.csv" to CsvExporter(),
            "$baseOutputName.pdf" to PdfExporter(),
            "$baseOutputName.json" to JsonExporter()
        )

        strategies.forEach { (filename, strategy) ->
            try {
                strategy.export(results, filename)
                println("✅ Successfully exported to: $filename")
            } catch (e: Exception) {
                println("❌ Failed to export to $filename: ${e.message}")
            }
        }
    }
}
