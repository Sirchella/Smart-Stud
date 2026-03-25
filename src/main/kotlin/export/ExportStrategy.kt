package export

import model.StudentResult

/**
 * Interface corresponding to the strategy pattern for exporting student results.
 */
interface ExportStrategy {
    fun export(results: List<StudentResult>, outputPath: String)
}
