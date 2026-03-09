data class Student(val name: String, val caMark: Int, val examMark: Int) {
    fun calculateTotal(): Int = caMark + examMark

    fun calculateGrade(): String {
        val total = calculateTotal()
        return when {
            total in 80..100 -> "A"
            total in 70..79 -> "B"
            total in 60..69 -> "C"
            total in 50..59 -> "D"
            else -> "F"
        }
    }

    fun isPassed(): Boolean = calculateTotal() >= 50
}

// Custom higher-order function that takes a list and a lambda action
fun processStudents(students: List<Student>, action: (Student) -> Unit) {
    for (student in students) {
        action(student)
    }
}

fun main() {
    // 1. Create a list of student objects
    val students = listOf(
        Student("Alice", 35, 50),
        Student("Bob", 20, 40),
        Student("Charlie", 30, 55),
        Student("Diana", 25, 45)
    )

    // 2. Demonstrate collection processing
    println("--- All Students (using forEach) ---")
    students.forEach { student ->
        println("${student.name} -> Total: ${student.calculateTotal()} G: ${student.calculateGrade()}")
    }

    // Filter passed students
    println("\n--- Passed Students (using filter) ---")
    val passedStudents = students.filter { it.isPassed() }
    println("Passed Students: ${passedStudents.joinToString(" ") { it.name }}")

    // Map to transform results
    println("\n--- Transformed Results (using map) ---")
    val results = students.map { "${it.name}: ${it.calculateGrade()}" }
    results.forEach { println(it) }

    // 3. Demonstrate custom higher-order function
    println("\n--- Custom Higher-Order Function ---")
    processStudents(students) { student ->
        println("${student.name} -> ${student.calculateGrade()}")
    }
}
