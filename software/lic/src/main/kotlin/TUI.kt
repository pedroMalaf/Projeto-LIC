import isel.leic.utils.Time

object TUI {
    fun init() {
        KeyReceiver.init()
        LCD.init()
    }

    fun writeLCD() {
        LCD.write(KBD.getKey())
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

    fun clearAndWrite(s: String, l: Int = 0, c: Int = 0) {
        LCD.clear()
        LCD.cursor(l, c)
        LCD.write(s)
    }

    /**
     * mMintenance mode screen
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

        clearAndWrite("Maintence mode", 0, 1)

        do {
            if (elapsed(timer) > 2500) {
                if (idx == options.size - 1) idx = 0
                else idx++
                clearAndWrite("Maintence mode", 0, 1)
                timer = Time.getTimeInMillis()
            }

            LCD.cursor(1, 0)
            LCD.write(options[idx])

            when (KBD.getKey()) {
                '1' -> { // print ticket

                }
                '2' -> maintenanceStationsScreen()
                '3' -> maintenanceCoinsScreen()
                '4' -> { // reset ?
                    if (yesNoQuestion("Reset counters?", 5000L)) {
                        Stations.resetStations()
                        CoinDeposit.resetQuantity()
                    }
                }
                '5' -> { // shutdown
                    if (yesNoQuestion("Shutdown?", 5000L))
                        return true
                    else
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
        val toCent = hashMapOf(
            5 to "0.05",
            10 to "0.10",
            20 to "0.20",
            50 to "0.50",
            100 to "1.00",
            200 to "2.00"
        )
        var arrowMode = false
        var keyIdx = 0

        // Displays coins info in the correct format
        fun writeCoins() {
            clearAndWrite("     ${toCent[coins[keyIdx]]}€")
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
        val cities = Stations.cities
        var keyIdx = 0
        var arrowMode = false

        // Writes to LCD city correctly formatted
        fun writeCity() {
            clearAndWrite(cities[keyIdx].name)
            LCD.newLine()
            LCD.write(String.format("%02d${if (arrowMode) "a" else ":"}", keyIdx))
            LCD.cursor(1, 14)
            LCD.write(String.format("%02d", cities[keyIdx].sold))
        }

        writeCity()
        while (true) {
            val key = KBD.waitKey(5000)
            if (key == KBD.NONE.toChar() || key == '#') {
                break
            }

            if (key == '*') {
                arrowMode = !arrowMode
                writeCity()
                continue
            }

            if ((key - '0') < cities.size) {
                // check if we can "autocomplete" 2 digit
                // i.e press 1 and then 2 gets us 12, but if 12 does not exist, gets 2
                val n = String.format("%d%d", keyIdx, key - '0').toInt()
                keyIdx = if (n < cities.size)
                    n
                else
                    key - '0'
                writeCity()
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