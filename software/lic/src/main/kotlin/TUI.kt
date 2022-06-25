import isel.leic.utils.Time

// EURO + ARROW SPECIAL CHARS
const val EURO_CHAR = 'e' //TODO:
const val ARROW_CHAR = 'a' // TODO:

/**
 * TUI
 * Contains functions to help us draw/handle things on LCD
 */
object TUI {

    /**
     * Inits TUI
     */
    fun init() {
        LCD.init()
        KeyReceiver.init()
    }

    /**
     * Writes key received to LCD
     */
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
     * Writes the "* - to print* to LCD.
     */
    fun toPrintText(rt: Boolean) {
        LCD.newLine()
        LCD.write("${if (rt) 1 else 0}  * to Print")
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
     * Writes on the LCD:
     *    city
     *  rt price
     */
    fun writeCityRtPrice(cityName: String, rt: Boolean, price: Int) {
        clearAndWrite(cityName, true)
        clearAndWrite(
            "${if (rt) 1 else 0}    ${centsToString(price)}$EURO_CHAR",
            l = 1,
            clear = false
        )
    }

    /**
     * Writes on LCD:
     *         value
     * idx arr       quantity
     */
    fun writeCoins(value: Int, quant: Int, arrowMode: Boolean, idx: Int) {
        clearAndWrite("${centsToString(value)}$EURO_CHAR", true)
        LCD.newLine()
        LCD.write("$idx${if (arrowMode) ARROW_CHAR else ":"}")
        LCD.cursor(1, 14)
        LCD.write(String.format("%02d", quant))
    }

    /**
     * Shows vending aborted screen.
     * Lambda is runned after (to get return value and eject coins)
     * Lambda int parameter is credit
     */
    fun vendingAbortedScreen(credit: Int, fn: (Int) -> Unit) {
        clearAndWrite("Vending aborted", true)
        clearAndWrite(
            "Return ${centsToString(credit)}$EURO_CHAR",
            true,
            l = 1,
            clear = false
        )
        fn(credit)
        Time.sleep(1000)

    }

    /**
     * Shows collecting ticket screen.
     * Lambda will be used to handle the ticket purchase logic.
     */
    fun collectTicketScreen(cityName: String, fn: () -> Unit) {
        clearAndWrite(cityName, true)
        clearAndWrite("Collect Ticket", true, 1, 0, false)
        fn()
        clearAndWrite("Thank you", true)
        clearAndWrite("Have a nice trip", true, 1, 0, false)
        Time.sleep(1500)
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