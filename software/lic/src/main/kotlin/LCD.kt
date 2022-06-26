import isel.leic.utils.Time

// SPECIAL CHARACTERS
const val EURO_CHAR = 0.toChar()
private const val EURO_CHAR_CODE = 0

const val UP_ARROW_CHAR = 1.toChar()
private const val UP_ARROW_CHAR_CODE = 1

const val DOWN_ARROW_CHAR = 2.toChar()
private const val DOWN_ARROW_CHAR_CODE = 2

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
    private const val CMD_CGRAM_MASK = 0x40 // 0b01000000
    private const val MAX_CHAR_LINE = 8

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

        // Load EURO char
        loadChar(EURO_CHAR_CODE, listOf(
            0b00111, //   111
            0b01000, //  1
            0b11111, // 11111
            0b01000, //  1
            0b11111, // 11111
            0b01000, //  1
            0b00111, //   111
            0b00000
        ))

        // Load UP ARROW char
        loadChar(UP_ARROW_CHAR_CODE, listOf(
            0b00100, //   1
            0b01110, //  111
            0b10101, // 1 1 1
            0b00100, //   1
            0b00100, //   1
            0b00100, //   1
            0b00100, //   1
            0b00000
        ))

        // Load DOWN ARROW char
        loadChar(DOWN_ARROW_CHAR_CODE, listOf(
            0b00100, //   1
            0b00100, //   1
            0b00100, //   1
            0b00100, //   1
            0b10101, // 1 1 1
            0b01110, //  111
            0b00100, //   1
            0b00000
        ))
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
        for (c in text) { write(c) }
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
     * Generates a new character to use in our LCD (using CGRAM commands)
     * [charCode] will represent the character code to use later.
     * [charLines] is the representation in bits of each character's line.
     */
    private fun loadChar(charCode: Int, charLines: List<Int>) {
        repeat(MAX_CHAR_LINE) { line ->
            val ACG = charCode.shl(3) or line // ACG = char_code[5..3] char_line[2..0]
            writeCMD(CMD_CGRAM_MASK or ACG) // go to specific char line
            writeDATA(charLines[line]) // draw the specific character bits on the line
        }
        writeCMD(0b10) // writes data into CGRAM
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

    LCD.clear()
    LCD.cursor(0, 0)
    DEBUG("testing custom char: $EURO_CHAR")
    Time.sleep(5000)

    DEBUG("[LCD::TESTBENCH] done")
}