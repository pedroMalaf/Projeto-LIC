object TUI {
    fun init() {
        KeyReceiver.init()
        LCD.init()
    }

    fun writeLCD() {
        LCD.write(KBD.getKey())
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