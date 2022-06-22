object TUI {
    fun init() {
        KeyReceiver.init()
        LCD.init()
    }

    fun writeLCD() {
        LCD.write(KBD.getKey())
    }

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

    fun maintenceCoinsScreen() {
        val coins = CoinDeposit.coins.keys.toList()
        val toCent = hashMapOf(
            5 to "0.05",
            10 to "0.10",
            20 to "0.20",
            50 to "0.50",
            100 to "1.00",
            200 to "2.00"
        )
        var keyIdx = 0

        clearAndWrite("     ${toCent[coins[keyIdx]]}€")
        while (true) {
            val key = KBD.waitKey(5000)
            if (key == KBD.NONE.toChar() || key == '#') {
                break
            }

            if (key in '0'..'5') {
                keyIdx = key - '0'
                clearAndWrite("     ${toCent[coins[keyIdx]]}€")
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