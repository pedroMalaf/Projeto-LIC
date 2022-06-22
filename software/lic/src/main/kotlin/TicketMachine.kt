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
                shutdown = TUI.maintenanceMode()
            }
            if (KBD.getKey() == '#') {
                println("# PRESSED")
            }
        }

        System.exit(1)
    }

}

fun main() {
    TicketMachine.init()
    TicketMachine.run()
}