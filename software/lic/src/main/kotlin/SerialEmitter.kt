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

    // bit channels
    private const val BUSY_MASK = 0x1 // bit 0
    private const val NOTSS_MASK = 0x2 // 1
    private const val SCLK_MASK = 0x4 // 2
    private const val SDX_MASK = 0x8 // 3

    //
    private const val SCLK = 10L
    private const val SLEEP_DEBUG = 500L

    /**
     * Sets up bit channels
     */
    fun init() {
        DEBUG("[SerialEmitter::init]")

        HAL.init(0)
        //HAL.clrBits(BUSY_MASK) // busy = 0
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
    fun send(addr: Destination, data: Int) {
        while (isBusy()) {
            DEBUG("Cant send frame (busy = 1). Trying again in 3 sec ...")
            Time.sleep(3000)
        }

        // add destination bit (lcd or td) to frame (msb)
        var frame = data.shl(1) or addr.value
        DEBUG("[SerialEmitter::send] sending frame ${AS_BINARY(frame)} (${addr.to})")

        var parityBit = 0

        // send frame (bit by bit)
        HAL.clrBits(NOTSS_MASK)
        repeat(10) {
            HAL.clrBits(SCLK_MASK) // sclk = 0

            // sdx and parity
            val sdx = frame and 1
            if (sdx == 1) HAL.setBits(SDX_MASK) else HAL.clrBits(SDX_MASK)
            parityBit = parityBit xor sdx
            DEBUG("[SerialEmitter::send] sdx: $sdx (parityBit = $parityBit)")
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
        DEBUG("[SerialEmitter::send] sending last sdx (parity bit): $parityBit")

        Time.sleep(SCLK)
        //HAL.setBits(BUSY_MASK)
        HAL.setBits(NOTSS_MASK)
        HAL.clrBits(SCLK_MASK)
        DEBUG("[SerialEmitter::send] full frame sent")
    }

    /**
     * Returns true if busy channel is ON
     */
    fun isBusy() = HAL.isBit(BUSY_MASK)
}
