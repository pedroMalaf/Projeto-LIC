import isel.leic.utils.Time

/**
 * Receives frame from Keyboard Reader
 */
object KeyReceiver {

    private const val FRAME_SIZE = 6

    fun init() {
        HAL.init()
        HAL.clrBits(TXCLK_MASK)
    }

    /**
     * Receives a frame and returns a key code on success, otherwise -1.
     */
    fun rcv(): Int {
        if (HAL.isBit(TXD_MASK)) {
            return -1
        }

        var frame = 0
        for (pos in 0 until FRAME_SIZE) {
            HAL.setBits(TXCLK_MASK) // TXCLK = 1
            HAL.clrBits(TXCLK_MASK) // TXCLK = 0

            val TXD = if (HAL.isBit(TXD_MASK)) 1 else 0
            frame = frame or (TXD shl pos) // add bit to frame
            //DEBUG("[KeyReceiver::rcv] TXD = $TXD")
        }

        HAL.setBits(TXCLK_MASK) // TXCLK = 1
        HAL.clrBits(TXCLK_MASK) // TXCLK = 0

        DEBUG("[KeyReceiver::rcv] frame = ${AS_BINARY(frame)}")

        // frame: start_bit[0], key[1..4], end_bit[5]
        val startBit = frame and 0b000001
        val endBit = (frame and 0b100000).shr(5)
        val key = frame and 0b011110
        return when {
            startBit == 0 -> -1 // error
            endBit == 1 -> -1 // error
            else -> (key shr 1) and 0b1111 // success!
        }
    }
}

fun main() {
    KeyReceiver_Testbench()
}

fun KeyReceiver_Testbench() {
    DEBUG("[KeyReceiver::TESTBENCH] starting")
    KeyReceiver.init()
    DEBUG("[KeyReceiver::TESTBENCH] put txd to 0")
    Time.sleep(5000)
    DEBUG("[KeyReceiver::TESTBENCH] put txd to 1 (start bit)")
    Time.sleep(5000)
    DEBUG("[KeyReceiver::TESTBENCH] press 1 key")
    Time.sleep(5000)
    DEBUG("[KeyReceiver::TESTBENCH] put txd to 0 (end bit)")
    Time.sleep(5000)
    DEBUG("[KeyReceiver::TESTBENCH] rcv: ${KeyReceiver.rcv()}")
    DEBUG("[KeyReceiver::TESTBENCH] done")
}
