import isel.leic.utils.Time

/**
 * Scans key input from the board keyboard.
 * Methods return '0'...'9', '#', '*' or [NONE]
 */
object KBD {

    const val NONE = 0;

    private val keys = listOf(
        '1', '4', '7', '*',
        '2', '5', '8', '0',
        '3', '6', '9', '#',
        'A', 'B', 'C', 'D'
    )

    fun init() {
        KeyReceiver.init()
    }

    /**
     * Interacts with Key Decode (1st phase)
     */
    private fun getKeyParallel(): Char {
        return getKeySerial()
    }

    /**
     * Interacts with Key Decode (2nd phase)
     */
    private fun getKeySerial(): Char {
        KeyReceiver.rcv().let { code ->
            return when {
                code != -1 -> keys[code]
                else -> NONE.toChar()
            }
        }
    }

    /**
     * Returns pressed key or [NONE].
     */
    fun getKey(): Char {
        if(HAL.isBit((TXD_MASK))) {
            return NONE.toChar()
        }

        val idx = KeyReceiver.rcv()
        return if (idx in 0..11) keys[idx] else NONE.toChar()
    }

    /**
     * Returns when the key is pressed (or [NONE]) after [timeout] ms.
     */
    fun waitKey(timeout: Long): Char {
        var key = NONE.toChar()
        val end = Time.getTimeInMillis() + timeout

        while (end >= Time.getTimeInMillis()) {
            key = getKeyParallel()
            if (key != NONE.toChar()) {
                DEBUG("Pressed $key")
                break
            }
        }

        return key
    }
}

fun main() {
    KBD_Testbench()
}

fun KBD_Testbench() {
    DEBUG("[KBD::TESTBENCH] starting")
    KBD.init()
    while (true) {
        val key = KBD.waitKey(1000*10)
        if (key == KBD.NONE.toChar()) {
            break
        }
    }
    DEBUG("[KBD::TESTBENCH] done")
}