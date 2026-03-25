package grading

import config.GradingConfig
import model.Student
import model.StudentResult

/**
 * Strategy interface for evaluating student grades.
 */
interface GradingStrategy {
    fun evaluate(student: Student, config: GradingConfig): StudentResult
}

/**
 * Standard implementation that assigns grades based directly on the provided configuration boundaries.
 */
class StandardGradingStrategy : GradingStrategy {
    override fun evaluate(student: Student, config: GradingConfig): StudentResult {
        val total = student.caMark + student.examMark
        val passed = total >= config.passMarkTotal
        
        // Find the band that matches the total score
        val band = config.gradeBands.find { total in it.minScore..it.maxScore }
            ?: config.gradeBands.last() // Fallback to lowest grade if not found

        return StudentResult(
            name = student.name,
            caMark = student.caMark,
            examMark = student.examMark,
            total = total,
            grade = band.grade,
            passed = passed,
            remark = band.remark
        )
    }
}

/**
 * Strict grading implementation where the minimum pass mark is fixed at 50, regardless of standard config.
 */
class StrictGradingStrategy : GradingStrategy {
    override fun evaluate(student: Student, config: GradingConfig): StudentResult {
        val total = student.caMark + student.examMark
        val passed = total >= 50
        
        // Find the band that matches the total score
        val band = config.gradeBands.find { total in it.minScore..it.maxScore }
            ?: config.gradeBands.last()

        return StudentResult(
            name = student.name,
            caMark = student.caMark,
            examMark = student.examMark,
            total = total,
            grade = band.grade,
            passed = passed,
            remark = band.remark
        )
    }
}

/**
 * Processor class that leverages a specific strategy to evaluate a list of students.
 */
class GradingProcessor(
    private val strategy: GradingStrategy,
    private val config: GradingConfig
) {
    /**
     * Processes a list of students, returning their results.
     */
    fun process(students: List<Student>): List<StudentResult> {
        return students.map { strategy.evaluate(it, config) }
    }

    /**
     * Higher-order function to process students and apply a custom action on each.
     */
    fun processStudents(students: List<Student>, action: (StudentResult) -> Unit) {
        students.forEach { student ->
            val result = strategy.evaluate(student, config)
            action(result)
        }
    }
}
