import isel.leic.utils.Time
import java.text.SimpleDateFormat
import java.util.*

val DATEFORMAT = SimpleDateFormat("dd/MM/yyyy HH:mm")

var waitingScreenDisplayed = false

fun showWaitingScreen() {
    if (!waitingScreenDisplayed) {
        LCD.clear()
        LCD.cursor(0, 1)
        LCD.write("Ticket to Ride")
        LCD.newLine()
        LCD.write(DATEFORMAT.format(Date()))
        waitingScreenDisplayed = true
    }

}

/**
 * Main app object
 */
object TicketMachine {
    fun init() {
        HAL.init()
        KBD.init()
        KeyReceiver.init()
        SerialEmitter.init()
        TicketDispenser.init()
        LCD.init()
        M.init()
        CoinDeposit.init()
        CoinAcceptor.init()
        Stations.init()
        TUI.init()
    }

    fun run() {

        var shutdown = false
        showWaitingScreen()

        // main loop
        while (!shutdown) {
            if (M.verify()) {
                waitingScreenDisplayed = false
                shutdown = MaintenceMode()
            }
            if (KBD.getKey() == '#') {
                println("# PRESSED")
            }
            showWaitingScreen()
        }
    }

}

fun MaintenceMode(): Boolean {
    val options = listOf(
        "1-Print Ticket",
        "2-Station Cnt.",
        "3-Coins Cnt.",
        "4-Reset Cnt.",
        "5-Shutdown"
    )
    var idx = 0
    var timeNow = Time.getTimeInMillis()

    LCD.clear()
    LCD.cursor(0, 1)
    LCD.write("Maintence mode")

    do {
        if (elapsed(timeNow) > 2500) {
            if (idx == options.size-1) idx = 0
            else idx++
            timeNow = Time.getTimeInMillis()
            LCD.clear()
            LCD.cursor(0, 1)
            LCD.write("Maintence mode") // TODO: always clearing
        }

        LCD.cursor(1, 0)
        LCD.write(options[idx])

        when (KBD.getKey()) {
            '1' -> {

            }
            '2' -> println("2")
            '3' -> println("3")
        }
    } while (M.verify())

    return false
}

fun elapsed(t: Long): Long {
    return Time.getTimeInMillis() - t
}

fun main() {
    TicketMachine.init()
    TicketMachine.run()
}