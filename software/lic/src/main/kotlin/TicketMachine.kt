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
            if (KBD.getKey() == '2' || KBD.getKey() == '8') {
                var i = 0
                var cities = Stations.cities
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