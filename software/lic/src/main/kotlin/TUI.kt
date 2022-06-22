import isel.leic.utils.Time
import java.text.SimpleDateFormat
import java.util.*

object TUI {
    private val DATEFORMAT = SimpleDateFormat("dd/MM/yyyy HH:mm")

    // Used to know when to redraw waiting message
    var waitingScreenDisplayed = false

    // Our current city // TODO: perguntar ao stor se é assim que funciona
    var origin = 0

    var updatedDate = DATEFORMAT.format(Date())

    // Useful in some cases to convert from cents to euro
    val toCent = hashMapOf(
        5 to "0.05",
        10 to "0.10",
        20 to "0.20",
        50 to "0.50",
        100 to "1.00",
        200 to "2.00"
    )

    /**
     *
     */
    fun init() {
        LCD.init()
        KeyReceiver.init()
    }

    fun writeLCD() {
        println(KBD.waitKey(10000))

    }

    /**
     * Asks a question [str] for [time]ms and returns true if answer is yes.
     */
    fun yesNoQuestion(str: String, time: Long): Boolean {
        LCD.clear()
        LCD.write(str)
        LCD.newLine()
        LCD.write("5-Yes  other-No")
        return KBD.waitKey(time) == '5'
    }

    /**
     * Clears and writes [s] on the LCD on cursor ([l], [c]) or centered instead
     */
    fun clearAndWrite(s: String, center: Boolean = false, l: Int = 0, c: Int = 0, clear: Boolean = true) {
        if (clear) LCD.clear()
        if (!center) LCD.cursor(l, c)
        else {
            val middle = 8
            val start = middle - (s.length / 2)
            LCD.cursor(l, start)
        }
        LCD.write(s)
    }

    /**
     * Shows waiting screen on LCD
     */
    fun showWaitingScreen() {
        val now = DATEFORMAT.format(Date())
        if (now != updatedDate){
            updatedDate = now
            waitingScreenDisplayed = false
        }
        if (!waitingScreenDisplayed) {
            clearAndWrite("Ticket To Ride", true)
            LCD.newLine()
            LCD.write(updatedDate.toString())
            waitingScreenDisplayed = true
        }
    }

    /**
     * Handles city selection and executes [fn] block.
     * The function returns if [returnIfHashtag] is true and '#' is pressed.
     * [showPrice] will show the price in the right side, if false, shows how many tickets were sold.
     * This can be useful to avoid duplicate code.
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
            clearAndWrite(cities[keyIdx].name, true)
            LCD.newLine()
            LCD.write(String.format("%02d${if (arrowMode) "a" else ":"}", keyIdx))
            if (!showPrice) {
                LCD.cursor(1, 14)
                LCD.write(String.format("%02d", cities[keyIdx].sold))
            } else {
                LCD.cursor(1, 11)
                val price = intToString(cities[keyIdx].price.toDouble())
                LCD.write("$price€")
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

    /**
     * Maintenance mode screen
     */
    fun maintenanceMode(): Boolean {
        val options = listOf(
            "1-Print Ticket",
            "2-Station Cnt.",
            "3-Coins Cnt.",
            "4-Reset Cnt.",
            "5-Shutdown"
        )
        var idx = 0
        var timer = Time.getTimeInMillis()

        clearAndWrite("Maintenance mode")

        do {
            if (elapsed(timer) > 2500) {
                if (idx == options.size - 1) idx = 0
                else idx++
                clearAndWrite("Maintenance mode")
                timer = Time.getTimeInMillis()
            }

            LCD.cursor(1, 0)
            LCD.write(options[idx])

            when (KBD.getKey()) {
                '1' -> testPrintTicket()
                '2' -> maintenanceStationsScreen()
                '3' -> maintenanceCoinsScreen()
                '4' -> { // reset ?
                    if (yesNoQuestion("Reset counters?", 5000L)) {
                        Stations.resetStations()
                        CoinDeposit.resetQuantity()
                    }
                }
                '5' -> { // shutdown
                    if (yesNoQuestion("Shutdown?", 5000L)) {
                        return true
                    } else
                        continue
                }
            }
        } while (M.verify())
        return false
    }

    /**
     * Maintenance coins screen
     */
    private fun maintenanceCoinsScreen() {
        val coins = CoinDeposit.coins.keys.toList()
        var arrowMode = false
        var keyIdx = 0

        // Display coins info in the correct format
        fun writeCoins() {
            clearAndWrite("${toCent[coins[keyIdx]]?.let { intToString(it.toDouble()) }}€", true)
            LCD.newLine()
            LCD.write("$keyIdx${if (arrowMode) "a" else ":"}")
            LCD.cursor(1, 14)
            LCD.write("${CoinDeposit.coins[coins[keyIdx]]}")
        }

        writeCoins()
        while (true) {
            val key = KBD.waitKey(5000)
            if (key == KBD.NONE.toChar() || key == '#') {
                break
            }

            if (key == '*') {
                arrowMode = !arrowMode
                writeCoins()
                continue
            }

            // handle arrow mode
            if ((key == '2' || key == '8') && arrowMode) {
                val up = key == '2'
                when {
                    up && keyIdx < 5 -> keyIdx++
                    !up && keyIdx > 0 -> keyIdx--
                    else -> continue
                }
                writeCoins()
                continue
            }

            // handle normal mode
            if (key in '0'..'5') {
                keyIdx = key - '0'
                writeCoins()
            }
        }
    }

    /**
     * Maintenance stations screen
     */
    private fun maintenanceStationsScreen() {
        handleCitySelection(true, false) { _, _, _ -> }
    }

    /**
     * Prints and waits for ticket collect.
     */
    fun collectTicket(cityName: String, id: Int, rt: Boolean) {
        clearAndWrite(cityName, true)
        clearAndWrite("Collect Ticket", true, 1, 0, false)
        TicketDispenser.print(id, origin, rt)
        Stations.addSold(cityName)
        origin = id
        while (SerialEmitter.isBusy()) {
        }
        clearAndWrite("Thank you", true)
        clearAndWrite("Have a nice trip", true, 1, 0, false)
        Time.sleep(1500)
    }

    /**
     * Simulates ticket printing (maintenance mode)
     */
    private fun testPrintTicket() {
        handleCitySelection(false, true) { key, city, id ->
            if (key == '#') {
                var rt = false
                var update = true // used to redraw screen ONLY when needed (when rt is pressed)

                while (true) {
                    if (update) {
                        clearAndWrite(city.name, true)
                        LCD.newLine()
                        LCD.write("${if (rt) 1 else 0}  * to Print")
                        update = false
                    }

                    when (KBD.getKey()) {
                        '*' -> {
                            collectTicket(city.name, id, rt)
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
     * Normal mode (buying ticket)
     */
    fun normalMode() {
        handleCitySelection(false, true) { key, city, id ->
            if (key == '#') {
                var rt = false
                var update = true // used to redraw screen ONLY when needed (when rt is pressed)
                var credit = 0

                while (true) {
                    if (update) {
                        clearAndWrite(city.name, true)
                        val price = intToString((city.price - credit).toDouble())
                        clearAndWrite("${if (rt) 1 else 0}    $price€", l = 1, clear = false)
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

                        if (credit >= city.price) {
                            collectTicket(city.name, id, rt)
                            CoinAcceptor.collectCoins()
                            return@handleCitySelection
                        }
                    }

                    // handle input
                    when (KBD.getKey()) {
                        '0' -> {
                            rt = !rt
                            update = true
                        }
                        '#' -> {
                            if (credit < city.price) {
                                clearAndWrite("Vending aborted", true)
                                clearAndWrite("Return ${intToString(credit.toDouble())}", true, l=1, clear=false)
                                CoinDeposit.returnValue(credit)
                                CoinAcceptor.ejectCoins()
                                Time.sleep(1000)
                                return@handleCitySelection
                            }
                        }
                    }
                }
            }
        }
    }
}

fun main() {
    TUI_Testbench()
}

fun TUI_Testbench() {
    DEBUG("[TUI::TESTBENCH] starting")
    TUI.init()
    TUI.writeLCD()
    //...
    DEBUG("[TUI::TESTBENCH] done")
}