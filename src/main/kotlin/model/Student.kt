package model

/**
 * Represents a student with their Continuous Assessment (CA) and Exam marks.
 */
data class Student(
    val name: String,
    val caMark: Int,
    val examMark: Int
)

/**
 * Represents the final graded result for a student.
 */
data class StudentResult(
    val name: String,
    val caMark: Int,
    val examMark: Int,
    val total: Int,
    val grade: String,
    val passed: Boolean,
    val remark: String
)
