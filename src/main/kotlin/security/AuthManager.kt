package security

/**
 * Singleton authentication manager handling simple user login and student data validation.
 */
object AuthManager {

    private val credentials = mapOf(
        "admin" to "admin123",
        "lecturer" to "grade2024"
    )

    /**
     * Validates if a provided username and password match any embedded profile.
     */
    fun login(username: String, password: String): Boolean {
        return credentials[username] == password
    }

    /**
     * Prompts the user via standard input for login.
     * Note: Full console password masking is dependent on System.console() being available.
     * In IDE environments where System.console() is null, it falls back to raw line reading.
     */
    fun promptLogin(): Boolean {
        print("Username: ")
        val username = readLine()?.trim() ?: ""

        val console = System.console()
        val password = if (console != null) {
            val passChars = console.readPassword("Password (input hidden): ")
            String(passChars ?: charArrayOf())
        } else {
            // Fallback for IDE runners. We cannot easily mask output with asterisk here securely.
            print("Password: ")
            readLine()?.trim() ?: ""
        }

        return login(username, password).also { success ->
            if (!success) {
                println("❌ Invalid credentials!")
            }
        }
    }

    /**
     * Validates typical student row inputs read from a spreadsheet or console.
     */
    fun validateStudent(name: String?, ca: Any?, exam: Any?): Boolean {
        if (name.isNullOrBlank()) {
            println("⚠️ Validation Error: Student name cannot be blank. Skipping record.")
            return false
        }
        
        val caMark = ca?.toString()?.toDoubleOrNull()?.toInt()
        if (caMark == null || caMark !in 0..40) {
            println("⚠️ Validation Error: CA mark for $name is invalid (must be 0-40, got $ca). Skipping.")
            return false
        }
        
        val examMark = exam?.toString()?.toDoubleOrNull()?.toInt()
        if (examMark == null || examMark !in 0..60) {
            println("⚠️ Validation Error: Exam mark for $name is invalid (must be 0-60, got $exam). Skipping.")
            return false
        }

        return true
    }
}
