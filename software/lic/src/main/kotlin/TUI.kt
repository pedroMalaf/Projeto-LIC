object TUI {


    fun init() {
        KeyReceiver.init()
        LCD.init()
    }

    fun writeLCD() {
        LCD.write(KBD.getKey())
    }
}