import isel.leic.utils.Time

/**
 * LCD
 *
 * Writes to the LCD using the 8 bit interface.
 */
object LCD {
    // Commands
    private const val CMD_DISPLAY_OFF = 0b0000_1000
    private const val CMD_DISPLAY_CLEAR = 0b0000_0001
    private const val CMD_DISPLAY_ENTRY_MODE_SET = 0b0000_0110
    private const val CMD_DISPLAY_ON = 0b0000_1111

    /**
     * Write command/data byte to LCD
     */
    private fun writeByteSerial(rs: Boolean, data: Int) {
        val RS = if (rs) 1 else 0
        val fullData = data.shl(1) or RS
        //DEBUG("[LCD::writeByteSerial] fullData = ${AS_BINARY(fullData)}")
        SerialEmitter.init()
        SerialEmitter.send(SerialEmitter.Destination.LCD, fullData, 0)
    }

    /**
     * Write command/data byte to LCD
     */
    fun writeByte(rs: Boolean, data: Int) {
        writeByteSerial(rs, data)
    }

    /**
     * Write command to LCD
     */
    private fun writeCMD(data: Int) {
        writeByte(false, data)
    }

    /**
     * Write data to LCD
     */
    private fun writeDATA(data: Int) {
        writeByte(true, data)
    }

    /**
     * Sets up LCD by sending the init sequence from the documentation
     */
    fun init() {
        writeCMD(0b0011_0000)
        Time.sleep(16)
        writeCMD(0b0011_0000)
        Time.sleep(5)
        writeCMD(0b0011_0000)

        writeCMD(0b0011_1000)
        writeCMD(CMD_DISPLAY_OFF)
        writeCMD(CMD_DISPLAY_CLEAR)
        writeCMD(CMD_DISPLAY_ENTRY_MODE_SET)
        writeCMD(CMD_DISPLAY_ON)
    }

    /**
     * Writes a char [c] to the current position
     */
    fun write(c: Char) {
        writeDATA(c.code)
    }

    /**
     * Writes a string ([text]) to the current position
     */
    fun write(text: String) {
        text.forEach { write(it) }
    }

    /**
     * Sends a command to change cursor position ('line':0..LINES-1, 'column':0..COLS-1)
     */
    fun cursor(line: Int, column: Int) {
        writeCMD((line * 0x40 + column) or 0x80)
    }

    /**
     * Cleans the display and sets cursor position to (0,0)
     */
    fun clear() {
        writeCMD(0b0000_0001) // CMD_DISPLAY_CLEAR
        cursor(0, 0)
    }

    /**
     * Places cursor at next line.
     */
    fun newLine() {
        cursor(1, 0)
    }
}

fun main() {
    LCD_Testbench()
}

fun LCD_Testbench() {
    DEBUG("[LCD::TESTBENCH] starting")

    LCD.init()
    Time.sleep(2000)

    LCD.clear()
    LCD.cursor(1, 1);
    DEBUG("writing \"hello world\" on LCD line 1")
    LCD.write("Now Playing:")

    LCD.cursor(1, 0)
    DEBUG("writing \"x\" on LCD line 2")
    LCD.write("YEAT")
    Time.sleep(5000)

    DEBUG("[LCD::TESTBENCH] done")
}