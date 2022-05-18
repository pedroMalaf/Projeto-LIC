import isel.leic.utils.Time

fun main() {
    LCD.init()
    LCD.writeByte(true, 0b1101_0110)
}

/**
 * LCD
 *
 * Writes to the LCD using the 8bit interface
 */
object LCD {
    // Display size
    private val LINES = 2
    private val COLS = 16

    /**
     * Write command/data byte to LCD
     */
    private fun writeByteSerial(rs: Boolean, data: Int) {
        val RS = if (rs) 1 else 0
        val fullData = RS.shl(8) or data
        SerialEmitter.send(SerialEmitter.Destination.LCD, fullData)
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
     * Sets up LCD by sending the init sequence from the docs
     */
    fun init() {
        Time.sleep(16)
        writeCMD(0b0011_0000)
        Time.sleep(5)
        writeCMD(0b0011_0000)
        Time.sleep(1) // should be 100 nanosec but ok
        writeCMD(0b0011_0000)

        writeCMD(0b0011_1000)
        writeCMD(0b0011_1000) // Display off
        writeCMD(0b0011_0001) // Display clear
        writeCMD(0b0011_0110) // Entry mode set
    }

    /**
     * Writes a char [c] to the current position
     */
    fun write(c: Char) {

    }

    /**
     * Writes a string ([text]) to the current position
     */
    fun write(text: String) {

    }

    /**
     * Sends a command to change cursor position ('line':0..LINES-1, 'column':0..COLS-1)
     */
    fun cursor(line: Int, column: Int) {
        // 0000010?--
        //writeCMD(0b0000010100)
    }

    /**
     * Cleans the display and sets cursor position to (0,0)
     */
    fun clear() {
        writeDATA(0b1)
        cursor(0, 0)
    }
}