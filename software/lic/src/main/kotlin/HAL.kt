import isel.leic.UsbPort

/**
 * HAL - Hardware Abstraction Layer
 *
 * Virtualization access to the UsbPort system
 */
object HAL {
    var lastState = 255  // all pins ON by default

    /**
     * Changes output leds state to [newState]
     */
    private fun changeState(newState: Int) {
        UsbPort.write(newState)
        lastState = newState
    }

    /**
     * Constructs the class, by settings bits to [state]
     */
    fun init(state: Int) {
        changeState(state)
    }

    /**
     * Returns true if [mask] bit is 1
     */
    fun isBit(mask: Int) = readBits(mask) == mask

    /**
     * Returns the values of the [mask]ed bits present in the UsbPort system
     */
    fun readBits(mask: Int) = mask and UsbPort.read()

    /**
     * Writes [value] [mask]ed bits in the UsbPort system
     */
    fun writeBits(mask: Int, value: Int) {
        val num = mask and value
        val numMask = mask.inv() and lastState
        changeState(numMask or num)
    }

    /**
     * Sets all [mask]ed bits in the UsbPort system to 1
     */
    fun setBits(mask: Int) {
        changeState(mask or lastState)
    }

    /**
     * Sets all [mask]ed bits in the UsbPort system to 0
     */
    fun clrBits(mask: Int) {
        changeState(mask.inv() and lastState)
    }
}
