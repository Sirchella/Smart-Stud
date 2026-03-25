package config

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths

/**
 * Represents a grading band with a minimum and maximum score for a specific grade.
 */
@Serializable
data class GradeBand(
    val grade: String,
    val minScore: Int,
    val maxScore: Int,
    val remark: String
)

/**
 * Main configuration class for the grading system.
 */
@Serializable
data class GradingConfig(
    val appName: String = "Student Grading System",
    val passMarkTotal: Int = 40,
    val caMaxMark: Int = 40,
    val examMaxMark: Int = 60,
    val gradeBands: List<GradeBand> = listOf(
        GradeBand("A", 70, 100, "Excellent"),
        GradeBand("B", 60, 69, "Good"),
        GradeBand("C", 50, 59, "Average"),
        GradeBand("D", 45, 49, "Below Average"),
        GradeBand("E", 40, 44, "Poor"),
        GradeBand("F", 0, 39, "Fail")
    )
) {
    companion object {
        /**
         * Loads configuration from a given JSON file path.
         * Falls back to default configuration if the file does not exist.
         */
        fun load(path: String = "config/grading_config.json"): GradingConfig {
            val file = File(path)
            return if (file.exists()) {
                try {
                    val jsonStr = file.readText()
                    Json.decodeFromString<GradingConfig>(jsonStr)
                } catch (e: Exception) {
                    println("⚠️ Error loading logic config: ${e.message}. Using default configuration.")
                    GradingConfig()
                }
            } else {
                println("⚠️ Config file not found at $path. Using default configuration.")
                GradingConfig()
            }
        }
    }
}
