import isel.leic.utils.Time
import java.text.SimpleDateFormat
import java.util.*

object TUI {
    private val DATEFORMAT = SimpleDateFormat("dd/MM/yyyy HH:mm")

    // Used to know when to redraw waiting message
    var waitingScreenDisplayed = false

    // Our current city // TODO: perguntar ao stor se é assim que funciona
    var origin = 0

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
        KeyReceiver.init()
        LCD.init()
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
        if (!waitingScreenDisplayed) {
            clearAndWrite("Ticket To Ride", true)
            LCD.newLine()
            LCD.write(DATEFORMAT.format(Date()))
            waitingScreenDisplayed = true
        }
    }

    /**
     * Handles city selection and executes [fn] block.
     * This can be useful to avoid duplicate code.
     * Lambda char is key pressed, String is city name, Int is city ID
     */
    private fun handleCitySelection(maintenance: Boolean, showPrice: Boolean, fn: (Char, String, Int) -> Unit) {
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
            }
            else {
                LCD.cursor(1, 13)
                // TODO: convert to euro
                LCD.write("${cities[keyIdx].price}€")
            }
        }

        // loop and show cities
        writeCity()
        while (true) {
            val key = KBD.waitKey(5000)
            if (key == KBD.NONE.toChar()) {
                break
            }

            if (key == '#' && maintenance)
                break

            if (key == '*') {
                arrowMode = !arrowMode
                writeCity()
                continue
            }

            // handle arrow mode
            if ((key == '2' || key == '8') && arrowMode) {
                val up = key == '2'
                println("entrou e $up")
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

            fn(key, cities[keyIdx].name, keyIdx)
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
            clearAndWrite("${toCent[coins[keyIdx]]}€", true)
            LCD.newLine()
            LCD.write("$keyIdx${if (arrowMode) "a" else ":"}")
            LCD.cursor(1, 14)
            LCD.write(String.format("%02d", CoinDeposit.coins[coins[keyIdx]]))
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
    fun collectTicket(city: String, id: Int, rt: Boolean) {
        clearAndWrite(city, true)
        clearAndWrite("Collect Ticket", true, 1, 0, false)
        TicketDispenser.print(id, origin, rt)
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
                        clearAndWrite(city, true)
                        LCD.newLine()
                        LCD.write("${if (rt) 1 else 0}  * to Print")
                        update = false
                    }

                    when (KBD.getKey()) {
                        '*' -> {
                            collectTicket(city, id, rt)
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
}

fun main() {
    TUI_Testbench()
}

fun TUI_Testbench() {
    DEBUG("[TUI::TESTBENCH] starting")
    TODO()
    DEBUG("[TUI::TESTBENCH] done")
}