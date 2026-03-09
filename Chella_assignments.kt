// 1. User Processing
data class User(val name: String, val email: String?)

fun processUsers() {
    println("--- User Processing ---")
    val users = listOf(
        User("Alex", "alex@example.com"),
        User("Blake", null),
        User("Casey", "casey@work.com")
    )

    users.forEach { user ->
        user.email?.let {
            println(it.uppercase())
        } ?: println("${user.name} has no email.")
    }
    val validEmailCount = users.count { it.email != null }
    println("Total users with valid emails: $validEmailCount\n")
}

// 2. Temperature Description
fun describeTemperature(temp: Int?): String {
    return when {
        temp == null -> "No data"
        temp <= 0 -> "Freezing"
        temp in 1..15 -> "Cold"
        temp in 16..25 -> "Mild"
        temp in 26..35 -> "Warm"
        temp in 36..45 -> "Hot"
        else -> "Extreme"
    }
}

fun processTemperatures() {
    println("--- Temperature Description ---")
    val temperatures = listOf(null, -5, 10, 20, 30, 40, 50, null)
    for (temp in temperatures) {
        println("Temp: ${temp ?: "null"} -> ${describeTemperature(temp)}")
    }
    println()
}

// 3. List Operations
fun processNumbers() {
    println("--- List Operations ---")
    val numbers: List<Int?> = listOf(1, null, 3, null, 5, 6, null, 8)
    val result = numbers.filterNotNull().map { it * 2 }.sum()
    println("Sum of doubled non-null numbers: $result\n")
}

fun main() {
    processUsers()
    processTemperatures()
    processNumbers()
}
