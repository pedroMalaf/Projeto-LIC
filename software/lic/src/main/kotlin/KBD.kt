/**
 * Scans key input from the board keyboard.
 * Methods return '0'...'9', '#', '*' or [NONE]
 */
object KBD {
    private const val NONE = 0;

    fun init() {
        TODO()
    }

    /**
     * Interacts with Key Decode (1st phase)
     */
    private fun getKeyParallel(): Char {
        TODO()
    }

    /**
     * Interacts with Key Decode (2nd phase)
     */
    private fun getKeySerial(): Char {
        TODO()
    }

    /**
     * Returns pressed key or [NONE]
     */
    fun getKey(): Char {
        TODO()
    }

    /**
     * Returns when the key is pressed (or [NONE]) after [timeout] ms
     */
    fun waitKey(timeout: Long): Char {
        TODO()
    }
}

fun main() {
    KBD_Testbench()
}

fun KBD_Testbench() {
    KBD.init()
    TODO()
}