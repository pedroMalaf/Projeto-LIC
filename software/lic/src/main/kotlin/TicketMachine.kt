/**
 * Main app object
 */
object TicketMachine {
    /**
     * Inits needed stuff
     */
    fun init() {
        HAL.init()
        LCD.init()
        KBD.init()
        KeyReceiver.init()
        SerialEmitter.init()
        TicketDispenser.init()
        M.init()
        CoinDeposit.init()
        CoinAcceptor.init()
        Stations.init()
        TUI.init()
    }

    /**
     * Main APP loop. Handles the important logic.
     */
    fun run() {
        var shutdown = false
        TUI.showWaitingScreen()

        // main loop
        while (!shutdown) {
            TUI.showWaitingScreen()

            // maintenance mode
            if (M.verify()) {
                TUI.updateWaitingScreen = false
                shutdown = TUI.maintenanceMode()
            }

            // buy ticket
            if (KBD.getKey() == '#') {
                TUI.normalMode()
                TUI.updateWaitingScreen = false
            }
        }

        // save on shutdown
        Stations.saveCities()
        CoinDeposit.saveCoins()
        LCD.clear()
        System.exit(1)
    }
}

fun main() {
    println("TicketMachine App by Pedro & Roberto")
    TicketMachine.init()
    TicketMachine.run()
}