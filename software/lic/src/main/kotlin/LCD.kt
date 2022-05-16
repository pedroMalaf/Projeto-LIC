import isel.leic.utils.Time

fun main() {
    LCD.init()
    LCD.writeByte(true, 0b1101_0110)
}

/**
 * LCD
 *
 * Escreve no LCD utilizando a interface a 8 bits
 */
object LCD {
    // Dimensão do display
    private val LINES = 2
    private val COLS = 16

    // Escreve um byte de comando/dados no LCD em série
    private fun writeByteSerial(rs: Boolean, data: Int) {
        val RS = if (rs) 1 else 0
        val fullData = RS.shl(8) or data
        SerialEmitter.send(SerialEmitter.Destination.LCD, fullData)
    }

    // Escreve um byte de comando/dados no LCD
    fun writeByte(rs: Boolean, data: Int) {
        writeByteSerial(rs, data)
    }

    // Escreve um comando no lcd
    private fun writeCMD(data: Int) {
        writeByte(false, data)
    }

    // Escreve um dado no LCD
    private fun writeDATA(data: Int) {
        writeByte(true, data)
    }

    // Envia uma sequência de iniciação para comunicação a 8 bits
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

    // Escreve um char na posição corrente
    fun write(c: Char) {

    }

    // Escreve uma string na posição corrente
    fun write(text: String) {

    }

    // Envia um comando para posicionar cursor ('line':0..LINES-1, 'column':0..COLS-1)
    fun cursor(line: Int, column: Int) {
        // 0000010?--
        //writeCMD(0b0000010100)
    }

    // Envia um comando para limpar o ecrã e posicionar o cursor em (0,0)
    fun clear() {
        writeDATA(0b1)
        cursor(0, 0)
    }
}