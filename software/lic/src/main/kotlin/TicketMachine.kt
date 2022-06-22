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

            // normal mode
            if (KBD.getKey() == '2' || KBD.getKey() == '8') {
                var i = 0
                val cities = Stations.cities
                println("programa vai começar")
                displayCity(i, cities)
                when(KBD.getKey()){
                    '2' -> {
                        i++
                        displayCity(i, cities)
                    }
                    '8' -> {
                        i--
                        displayCity(i, cities)
                    }
                    '#' -> {
                        println("iniciar a compra do bilhete - inserir moedas")
                        paymentInitialized() // função que verifica as moedas e etc
                        if (HAL.isBit(0x1)){
                            println("o bilhete foi pago e retirado com sucesso")
                            Stations.addSold("")
                            Stations.saveCities()
                        }
                    }
                    '*' -> 0 //ainda não percebi mt bem oqq o * vai fazer
                }
            }
        }

        // save on shutdown
        Stations.saveCities()
        CoinDeposit.saveCoins()
        System.exit(1)
    }

    /**
     * Displays current city [cities[i]] on the LCD
     */
    private fun displayCity(i: Int, cities: MutableList<Stations.City>){
        LCD.clear()
        LCD.cursor(0,0)
        LCD.write("") // nome da próxima cidade
        LCD.cursor(1,0)
        LCD.write("") // preço da próxima cidade
    }

    private fun paymentInitialized(){

    }

}

fun main() {
    TicketMachine.init()
    TicketMachine.run()
}