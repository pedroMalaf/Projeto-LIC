import isel.leic.utils.Time

/**
 * LCD
 *
 * Writes to the LCD using the 8 bit interface
 */
object LCD {
    // Display size
    private val LINES = 2
    private val COLS = 16

    private const val CMD_DISPLAY_OFF = 0b0000_1000
    private const val CMD_DISPLAY_CLEAR = 0b0000_0001
    private const val CMD_DISPLAY_ENTRY_MODE_SET = 0b0000_0110


    /**
     * Write command/data byte to LCD
     */
    private fun writeByteSerial(rs: Boolean, data: Int) {
        val RS = if (rs) 1 else 0
        val fullData = RS.shl(8) or data
        DEBUG("[LCD::writeByteSerial] fullData = ${AS_BINARY(fullData)}")
        SerialEmitter.init()
        SerialEmitter.send(SerialEmitter.Destination.LCD, fullData, 10)
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
        Time.sleep(16)
        writeCMD(0b0011_0000)
        Time.sleep(5)
        writeCMD(0b0011_0000)
        Time.sleep(1) // should be 100 nanoseconds but this should work
        writeCMD(0b0011_0000)

        writeCMD(0b0011_1000)
        writeCMD(CMD_DISPLAY_OFF)
        writeCMD(CMD_DISPLAY_CLEAR)
        writeCMD(CMD_DISPLAY_ENTRY_MODE_SET)
        writeCMD(0b0000_1111)
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
        val ADD = (39 * line + column) and 0b000_1111_111
        writeCMD(ADD or 0b1_0000_000)
    }

    /**
     * Cleans the display and sets cursor position to (0,0)
     */
    fun clear() {
        writeDATA(CMD_DISPLAY_CLEAR)
        cursor(0, 0)
    }
}