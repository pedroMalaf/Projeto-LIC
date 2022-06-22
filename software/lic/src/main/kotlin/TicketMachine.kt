import java.text.SimpleDateFormat
import java.util.*



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
        TUI.showWaitingScreen()

        // main loop
        while (!shutdown) {
            TUI.showWaitingScreen()

            // maintenance mode
            if (M.verify()) {
                TUI.waitingScreenDisplayed = false
                shutdown = TUI.maintenanceMode()
            }

            if (KBD.getKey() == '#') {
                TUI.normalMode()
                TUI.waitingScreenDisplayed = false
            }
        }

        // save on shutdown
        Stations.saveCities()
        CoinDeposit.saveCoins()
        System.exit(1)
    }
}

fun main() {
    TicketMachine.init()
    TicketMachine.run()
}