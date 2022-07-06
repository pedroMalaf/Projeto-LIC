import isel.leic.utils.Time
import java.text.SimpleDateFormat
import java.util.*
import kotlin.system.exitProcess

/**
 * Main APP object.
 */
object TicketMachine {
    // Used to know when to redraw waiting message
    var updateWaitingScreen = false

    // Our current city
    private var origin = 6

    // Updated date + format
    private val DATEFORMAT = SimpleDateFormat("dd/MM/yyyy HH:mm")
    private var updatedDate = DATEFORMAT.format(Date())

    /**
     * Inits needed stuff for APP.
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
        waitingScreen()

        // main loop
        while (!shutdown) {
            waitingScreen()

            // maintenance mode
            if (M.verify()) {
                updateWaitingScreen = false
                shutdown = maintenanceModeScreen()
            }

            // buy ticket
            if (KBD.getKey() == '#') {
                normalModeScreen()
                updateWaitingScreen = false
            }
        }

        // save on shutdown
        Stations.saveCities()
        CoinDeposit.saveCoins()
        LCD.clear()
        exitProcess(1)
    }

    /**
     * Shows waiting screen.
     */
    private fun waitingScreen() {
        val now = DATEFORMAT.format(Date())
        if (now != updatedDate) {
            updatedDate = now
            updateWaitingScreen = false
        }
        if (!updateWaitingScreen) {
            TUI.clearAndWrite("Ticket To Ride", true)
            LCD.newLine()
            LCD.write(updatedDate.toString())
            updateWaitingScreen = true
        }
    }

    /**
     * Maintenance mode screen.
     */
    private fun maintenanceModeScreen(): Boolean {
        val options = listOf(
            "1-Print Ticket",
            "2-Station Cnt.",
            "3-Coins Cnt.",
            "4-Reset Cnt.",
            "5-Shutdown"
        )
        var idx = 0
        var timer = Time.getTimeInMillis()

        TUI.clearAndWrite("Maintenance mode")

        do {
            if (elapsed(timer) > 2500) {
                if (idx == options.size - 1) idx = 0
                else idx++
                TUI.clearAndWrite("Maintenance mode")
                timer = Time.getTimeInMillis()
            }

            LCD.cursor(1, 0)
            LCD.write(options[idx])

            when (KBD.getKey()) {
                '1' -> testPrintTicket()
                '2' -> maintenanceStationsScreen()
                '3' -> maintenanceCoinsScreen()
                '4' -> { // reset
                    if (TUI.yesNoQuestion("Reset counters?", 5000L)) {
                        Stations.resetStations()
                        CoinDeposit.resetQuantity()
                    }
                }

                '5' -> { // shutdown
                    if (TUI.yesNoQuestion("Shutdown?", 5000L)) return true
                    else continue
                }
            }
        } while (M.verify())
        return false
    }

    /**
     * Simulates ticket printing (maintenance mode)
     */
    private fun testPrintTicket() {
        handleCitySelection(returnIfHashtag = false, showPrice = true) { key, city, id ->
            if (key == '#') {
                var rt = false
                var update = true // used to redraw screen ONLY when needed (when rt is pressed)

                while (true) {
                    if (update) {
                        TUI.clearAndWrite(city.name, true)
                        TUI.toPrintText(rt)
                        update = false
                    }

                    when (KBD.getKey()) {
                        '*' -> {
                            TUI.collectTicketScreen(city.name) {
                                TicketDispenser.print(id, origin, rt)
                                while (SerialEmitter.isBusy());
                            }
                            return@handleCitySelection
                        }

                        '0' -> {
                            rt = !rt
                            update = true
                        }
                    }
                }
            }
        }
    }

    /**
     * Coins screen (maintenance mode)
     */
    private fun maintenanceCoinsScreen() {
        val coins = CoinDeposit.coins.keys.toList()
        var arrowMode = false
        var keyIdx = 0
        val toCent = listOf(5, 10, 20, 50, 100, 200)

        TUI.writeCoins(toCent[keyIdx], CoinDeposit.coins[coins[keyIdx]] ?: 0, arrowMode, keyIdx)
        while (true) {
            val key = KBD.waitKey(5000)
            if (key == KBD.NONE.toChar() || key == '#') {
                break
            }

            if (key == '*') {
                arrowMode = !arrowMode
                TUI.writeCoins(toCent[keyIdx], CoinDeposit.coins[coins[keyIdx]] ?: 0, arrowMode, keyIdx)
                continue
            }

            // handle arrow mode
            if ((key == '2' || key == '8') && arrowMode) {
                val up = key == '2'
                when {
                    up && keyIdx < 5 -> keyIdx++
                    !up && keyIdx > 0 -> keyIdx--
                    up && keyIdx == 5 -> keyIdx = 0
                    !up && keyIdx == 0 -> keyIdx = 5
                    else -> continue
                }
                TUI.writeCoins(toCent[keyIdx], CoinDeposit.coins[coins[keyIdx]] ?: 0, arrowMode, keyIdx)
                continue
            }

            // handle normal mode
            if (key in '0'..'5') {
                keyIdx = key - '0'
                TUI.writeCoins(toCent[keyIdx], CoinDeposit.coins[coins[keyIdx]] ?: 0, arrowMode, keyIdx)
            }
        }
    }

    /**
     * Stations screen (maintenance mode)
     */
    private fun maintenanceStationsScreen() {
        handleCitySelection(returnIfHashtag = true, showPrice = false) { _, _, _ -> }
    }

    /**
     * Normal mode (buying ticket).
     */
    private fun normalModeScreen() {
        handleCitySelection(returnIfHashtag = false, showPrice = true) { key, city, id ->
            if (key == '#') {
                var rt = false
                var update = true // used to redraw screen ONLY when needed (when rt is pressed)
                var credit = 0

                var mult = 1 // multiply by 2 if RT (1 is default because no RT by default)
                var finalPrice = mult * city.price

                while (true) {
                    if (update) {
                        TUI.writeCityRtPrice(city.name, rt, finalPrice - credit)
                        update = false
                    }

                    // if a coin is inserted
                    if (CoinAcceptor.hasCoin()) {
                        update = true

                        // insert coin and check if we can already buy the ticket
                        val coin = CoinAcceptor.getCoinValue()
                        CoinDeposit.insertCoin(coin)
                        credit += coin
                        CoinAcceptor.acceptCoin()

                        if (credit >= finalPrice) {
                            TUI.collectTicketScreen(city.name) {
                                TicketDispenser.print(id, origin, rt)
                                while (!SerialEmitter.isBusy()) {
                                    DEBUG("Waiting for collect")
                                    Time.sleep(50)
                                }
                                Stations.addSold(city.name)
                                if (!rt) {
                                    DEBUG("RoundTrip false, setting next origin to destiny")
                                    origin = id
                                } else {
                                    DEBUG("RoundTrip true, adding also sold ticket to destiny")
                                    Stations.addSold(origin)
                                }
                            }

                            CoinAcceptor.collectCoins()
                            return@handleCitySelection
                        }
                    }

                    // handle input
                    when (KBD.getKey()) {
                        '0' -> {
                            rt = !rt
                            update = true
                            mult = if (rt) 2 else 1 // multiply by 2 if RT
                            finalPrice = mult * city.price // update final price
                        }

                        '#' -> {
                            TUI.vendingAbortedScreen(credit) {
                                CoinDeposit.returnValue(it)
                                CoinAcceptor.ejectCoins()
                            }
                            return@handleCitySelection
                        }
                    }
                }
            }
        }
    }

    /**
     * Handles city selection and executes [fn] block.
     * The function returns if [returnIfHashtag] is true and '#' is pressed.
     * [showPrice] will show the price on the right side, if false, shows how many tickets were sold.
     * **This can be useful to avoid duplicate code.**
     * Lambda char is key pressed, String is city object, Int is city ID
     */
    private fun handleCitySelection(
        returnIfHashtag: Boolean, showPrice: Boolean, fn: (Char, Stations.City, Int) -> Unit
    ) {
        val cities = Stations.cities
        var keyIdx = 0
        var arrowMode = false

        // Writes to LCD city correctly formatted
        fun writeCity() {
            TUI.clearAndWrite(cities[keyIdx].name, true)
            LCD.newLine()
            val str = String.format("%02d${if (arrowMode) "$UP_ARROW_CHAR$DOWN_ARROW_CHAR" else ":"}", keyIdx)
            LCD.write(str)
            if (!showPrice) {
                LCD.cursor(1, 14)
                LCD.write(String.format("%02d", cities[keyIdx].sold))
            } else {
                LCD.cursor(1, 11)
                val price = centsToString(cities[keyIdx].price)
                LCD.write("$price$EURO_CHAR")
            }
        }

        // loop and show cities
        writeCity()
        while (true) {
            val key = KBD.waitKey(5000)
            if (key == KBD.NONE.toChar()) {
                break
            }

            if (key == '#' && returnIfHashtag)
                break

            if (key == '*') {
                arrowMode = !arrowMode
                writeCity()
                continue
            }

            // handle arrow mode
            if ((key == '2' || key == '8') && arrowMode) {
                val up = key == '2'
                when {
                    up && keyIdx != cities.size - 1 -> keyIdx++
                    !up && keyIdx > 0 -> keyIdx--
                    up && keyIdx == cities.size - 1 -> keyIdx = 0
                    !up && keyIdx == 0 -> keyIdx = cities.size - 1
                    else -> continue
                }
                writeCity()
                continue
            }

            // handle normal mode
            if ((key - '0') < cities.size && key != '#') {
                // check if we can "autocomplete" 2 digit
                // i.e press 1 and then 2 gets us 12, but if 12 does not exist, gets 2
                val n = String.format("%d%d", keyIdx, key - '0').toInt()
                keyIdx = if (n < cities.size)
                    n
                else
                    key - '0'
                writeCity()
            }

            fn(key, cities[keyIdx], keyIdx)
        }
    }
}

//
fun main() {
    println("TicketMachine App by Pedro & Roberto")
    TicketMachine.init()
    TicketMachine.run()
}