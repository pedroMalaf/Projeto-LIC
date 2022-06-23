import isel.leic.utils.Time

/**
 * Main app object
 */
object TicketMachine {
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

            // buy ticket
            if (KBD.getKey() == '#') {
                TUI.normalMode()
                TUI.waitingScreenDisplayed = false
            }
        }

        // save on shutdown
        Stations.saveCities()
        CoinDeposit.saveCoins()
        LCD.clear()
        System.exit(1)
    }
}

/*
fun tb_KeyReceiver(){
    KeyReceiver.init()
    while(true){
        Time.sleep(200)
        println(KeyReceiver.rcv())
    }
}
 */

fun main() {
    println("TicketMachine App by Pedro & Roberto")
    TicketMachine.init()
    TicketMachine.run()
}