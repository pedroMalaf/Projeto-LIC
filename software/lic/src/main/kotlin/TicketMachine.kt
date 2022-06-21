import java.text.SimpleDateFormat
import java.util.*

val DATEFORMAT = SimpleDateFormat("dd/MM/yyyy HH:mm")

fun showWaitingScreen() {
    LCD.clear()
    LCD.cursor(0, 1)
    LCD.write("Ticket to Ride")
    LCD.newLine()
    LCD.write(DATEFORMAT.format(Date()))
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
    LCD.clear()
    LCD.cursor(0, 1)
    LCD.write("Maintence mode")

    do {
        when (KBD.getKey()) {
            '1' -> println("1")
            '2' -> println("2")
            '3' -> println("3")
        }
    } while (M.verify())

    return false
}

fun main() {
    TicketMachine.init()
    TicketMachine.run()
}