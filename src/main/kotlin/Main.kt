import config.GradingConfig
import console.ConsoleApp
import security.AuthManager
import kotlin.system.exitProcess

fun main() {
    println("=========================================")
    println("   Welcome to Student Grading System     ")
    println("=========================================")

    var attempts = 0
    var loggedIn = false

    while (attempts < 3) {
        loggedIn = AuthManager.promptLogin()
        if (loggedIn) {
            break
        }
        attempts++
        val remaining = 3 - attempts
        if (remaining > 0) {
            println("You have $remaining attempts left.\n")
        }
    }

    if (!loggedIn) {
        println("❌ Maximum login attempts reached. Exiting system.")
        exitProcess(1)
    }

    println("\n✅ Login Successful!\n")

    val config = GradingConfig.load()
    val app = ConsoleApp(config)
    app.run()
}
