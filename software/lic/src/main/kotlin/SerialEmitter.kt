import isel.leic.utils.Time

/**
 * SerialEmitter
 *
 * Sends the frame to the SerialReceiver module (IOS)
 */
object SerialEmitter {
    enum class Destination(val value: Int, val to: String) {
        LCD(0, "LCD"),
        TICKER_DISPENSER(1, "TICKET_DISPENSER")
    }

    //
    private const val SCLK = 5L

    /**
     * Sets up bit channels
     */
    fun init() {
        //DEBUG("[SerialEmitter::init]")
        HAL.init(0)
        HAL.setBits(NOTSS_MASK) // not_ss = 1
    }

    /**
     * Sends the 11bit frame to SerielReceiver hardware module.
     *
     * The frame should look like this: originID[6..9] destinyID[2..5] rt[1] lcd_td[0]
     * (+ the last bit sent which is the parity bit)
     *
     * @param addr Where to send the frame to (LCD or TICKET_DISPENSER)
     * @param data originID[5..8] destinyID[1..4] rt[0]
     */
    fun send(addr: Destination, data: Int, SLEEP_DEBUG: Long = 500L) {
        while (isBusy()) {
            DEBUG("Cant send frame (busy = 1). Trying again in 1 sec ...")
            Time.sleep(1000)
        }

        // add destination bit (lcd or td) to frame (msb)
        var frame = data.shl(1) or addr.value
        //DEBUG("[SerialEmitter::send] sending frame ${AS_BINARY(frame)} (${addr.to})")

        var parityBit = 0

        // send frame (bit by bit)
        HAL.clrBits(NOTSS_MASK)
        repeat(10) {
            HAL.clrBits(SCLK_MASK) // sclk = 0

            // sdx and parity
            val sdx = frame and 1
            if (sdx == 1) HAL.setBits(SDX_MASK) else HAL.clrBits(SDX_MASK)
            parityBit = parityBit xor sdx
            //DEBUG("[SerialEmitter::send] sdx: $sdx (parityBit = $parityBit)")
            frame = frame.shr(1)

            Time.sleep(SCLK)
            HAL.setBits(SCLK_MASK) // sclk = 1

            Time.sleep(SLEEP_DEBUG)
        }

        // send last bit (parity)
        HAL.clrBits(SCLK_MASK) // sclk = 0
        Time.sleep(SCLK)
        if (parityBit == 1) HAL.setBits(SDX_MASK) else HAL.clrBits(SDX_MASK)
        HAL.setBits(SCLK_MASK) // sclk = 1
        //DEBUG("[SerialEmitter::send] sending last sdx (parity bit): $parityBit")

        Time.sleep(SCLK)
        HAL.setBits(NOTSS_MASK)
        HAL.clrBits(SCLK_MASK)
        //DEBUG("[SerialEmitter::send] full frame sent")
    }

    /**
     * Returns true if busy channel is ON
     */
    fun isBusy() = HAL.isBit(BUSY_MASK)
}

fun main() {
    SerialEmitter_Testbench()
}

fun SerialEmitter_Testbench() {
    DEBUG("[SerialEmitter::TESTBENCH] Starting")

    // README: if testing on real board, make sure to manipulate switches (?)
    SerialEmitter.init()
    SerialEmitter.send(SerialEmitter.Destination.TICKER_DISPENSER, 0b001000011)

    DEBUG("[SerialEmitter::TESTBENCH] Done")
}