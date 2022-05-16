import isel.leic.utils.Time

fun main() {
    SerialEmitterTestbench(0b001000011)
}

/**
 * Serial Emitter
 *
 * Envia tramas para os diferentes módulos Serial Receiver
 */
object SerialEmitter {
    enum class Destination { LCD, TICKER_DISPENSER }

    // Canais:
    private const val BUSY_MASK = 0x1 // bit 0
    private const val NOTSS_MASK = 0x2 // 1
    private const val SCLK_MASK = 0x4 // 2
    private const val SDX_MASK = 0x8 // 3

    const val SCLK = 5L
    const val SLEEP_DEBUG = 500L

    fun init() {
        // busy = 0
        HAL.clrBits(BUSY_MASK)

        // not_ss = 1
        HAL.setBits(NOTSS_MASK)
    }

    // Envia uma trama para o SerielReceiver identificado o destino em addr e os bits de dados em data
    fun send(addr: Destination, data: Int) {
        // data = origem destino rt (ex: 67 = 0010 0001 1)
        val d = if (addr == Destination.TICKER_DISPENSER) 1 else 0

        // adicionar bit de destination (lcd ou td) ao data (bit de maior peso)
        var fullSdx = d.shl(9) or data

        // iterar e variar/enviar SCLK e SDX (um de cada vez)
        HAL.clrBits(NOTSS_MASK)
        for (i in 0 until 9) {
            println("Serial Emitter sending: ${printNum(fullSdx)}")
            // sclk = 0
            HAL.clrBits(SCLK_MASK)

            Time.sleep(SCLK)

            // sclk = 1
            HAL.setBits(SCLK_MASK)

            // sdx
            val sdx = fullSdx and 1
            if (sdx == 1) HAL.setBits(SDX_MASK) else HAL.clrBits(SDX_MASK)

            fullSdx = fullSdx.shr(1)
            Time.sleep(SLEEP_DEBUG)
        }

        HAL.setBits(BUSY_MASK)
        HAL.setBits(NOTSS_MASK)
        HAL.clrBits(SCLK_MASK)
    }

    // Retorna true se o canal série estiver ocupado
    fun isBusy(): Boolean {
        return HAL.isBit(BUSY_MASK)
    }
}

fun SerialEmitterTestbench(data: Int) {
    // README: if testing on real board, make sure to manipulate switches
    SerialEmitter.init()

    if (SerialEmitter.isBusy())
        println("isBusy should start at false!")

    SerialEmitter.send(SerialEmitter.Destination.TICKER_DISPENSER, data)

    if (!SerialEmitter.isBusy())
        println("isBusy should return true!")
}