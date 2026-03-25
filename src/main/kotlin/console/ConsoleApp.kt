package console

import config.GradingConfig
import export.ExportManager
import grading.GradingProcessor
import grading.StandardGradingStrategy
import grading.StrictGradingStrategy
import model.StudentResult
import reader.ExcelReader

/**
 * Main console application controlling the flow and user interaction.
 */
class ConsoleApp(private val config: GradingConfig) {

    fun run() {
        showBanner()

        print("\nEnter input file path (default: students_input.xlsx): ")
        var inputPath = readLine()?.trim()
        if (inputPath.isNullOrEmpty()) {
            inputPath = "students_input.xlsx"
        }

        println("\nChoose Grading Strategy:")
        println("[1] Standard Grading (Uses Configured Pass Mark)")
        println("[2] Strict Grading (Fixed 50 Pass Mark)")
        print("Your choice: ")
        
        val strategyChoice = readLine()?.trim()
        val strategy = when (strategyChoice) {
            "2" -> StrictGradingStrategy()
            else -> StandardGradingStrategy()
        }

        val processor = GradingProcessor(strategy, config)

        try {
            val students = ExcelReader.readStudents(inputPath)
            if (students.isEmpty()) {
                println("⚠️ No valid students found in the input file.")
                return
            }

            val results = processor.process(students)
            printResultsTable(results)
            printSummary(results)

            promptExport(results)

        } catch (e: Exception) {
            println("❌ Error processing students: ${e.message}")
        }
    }

    private fun showBanner() {
        val banner = """
            ====================================================================
               ____                _            _                
              / ___|_ __ __ _   __| | ___ _ __ | |               
             | |  _| '__/ _` | / _` |/ _ \ '_ \| |               
             | |_| | | | (_| || (_| |  __/ | | |_|               
              \____|_|  \__,_(_)__,_|\___|_| |_(_)               
                                                                 
             ${config.appName}
            ====================================================================
        """.trimIndent()
        println(banner)
    }

    private fun printResultsTable(results: List<StudentResult>) {
        println("\n┌───────────────────────────┬──────┬──────┬───────┬───────┬──────────────┬────────┐")
        println("│ Name                      │  CA  │ Exam │ Total │ Grade │ Remark       │ Status │")
        println("├───────────────────────────┼──────┼──────┼───────┼───────┼──────────────┼────────┤")

        results.forEach { r ->
            val nameStr = r.name.padEnd(25).take(25)
            val caStr = r.caMark.toString().padEnd(4)
            val examStr = r.examMark.toString().padEnd(4)
            val totalStr = r.total.toString().padEnd(5)
            val gradeStr = r.grade.padEnd(5)
            val remarkStr = r.remark.padEnd(12).take(12)
            val statusStr = (if (r.passed) "PASS" else "FAIL").padEnd(6)

            println("│ $nameStr │  $caStr│  $examStr│  $totalStr│  $gradeStr│ $remarkStr │ $statusStr │")
        }
        println("└───────────────────────────┴──────┴──────┴───────┴───────┴──────────────┴────────┘")
    }

    private fun printSummary(results: List<StudentResult>) {
        val count = results.size
        val passed = results.count { it.passed }
        val failed = count - passed
        val maxScore = results.maxOfOrNull { it.total } ?: 0
        val minScore = results.minOfOrNull { it.total } ?: 0
        val average = if (count > 0) results.sumOf { it.total }.toDouble() / count else 0.0

        println("\n--- Summary ---")
        println("Total Students : $count")
        println("Passed         : $passed")
        println("Failed         : $failed")
        println("Highest Score  : $maxScore")
        println("Lowest Score   : $minScore")
        println("Average Score  : ${"%.2f".format(average)}")
        println("---------------")
    }

    private fun promptExport(results: List<StudentResult>) {
        println("\nWould you like to export the results?")
        println("[1] Export All Formats (Excel, CSV, PDF, JSON)")
        println("[2] Skip Export")
        print("Your choice: ")

        val choice = readLine()?.trim()
        if (choice == "1") {
            print("Enter base output name (default: students_output): ")
            var baseName = readLine()?.trim()
            if (baseName.isNullOrEmpty()) {
                baseName = "students_output"
            }
            ExportManager.exportAll(results, baseName)
        } else {
            println("Export skipped.")
        }
    }
}
