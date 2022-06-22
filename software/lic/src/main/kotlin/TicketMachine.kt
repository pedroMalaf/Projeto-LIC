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
            showWaitingScreen()
            if (M.verify()) {
                waitingScreenDisplayed = false
                shutdown = MaintenceMode()
            }
            if (KBD.getKey() == '#') {
                println("# PRESSED")
            }
        }

        System.exit(1)
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
    var timer = Time.getTimeInMillis()

    LCD.clear()
    LCD.cursor(0, 1)
    LCD.write("Maintence mode")

    do {
        if (elapsed(timer) > 2500) {
            if (idx == options.size - 1) idx = 0
            else idx++
            TUI.clearAndWrite("Maintence mode", 0, 1)
            timer = Time.getTimeInMillis()
        }

        LCD.cursor(1, 0)
        LCD.write(options[idx])

        when (KBD.getKey()) {
            '1' -> { // print ticket

            }
            '2' -> { // station ?

            }
            '3' -> TUI.maintenceCoinsScreen()
            '4' -> { // reset ?

            }
            '5' -> { // shutdown
                if (TUI.yesNoQuestion("Shutdown?", 5000L))
                    return true
                else
                    continue
            }
        }
    } while (M.verify())

    return false
}


fun main() {
    TicketMachine.init()
    TicketMachine.run()
}