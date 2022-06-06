import isel.leic.UsbPort
import isel.leic.utils.Time

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
    fun init(state: Int = lastState) {
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

fun main() {
    HAL_Testbench()
}

// Testbench (RUN THIS WITH BREAKPOINTS TO DEBUG LEDS)
fun HAL_Testbench() {
    DEBUG("[HAL::TESTBENCH] Starting")
    // README: turn switches on if testing on real board
    HAL.init(146)

    // readBits
    // state = 146 (1001 0010) ; mask = 57 (0011 1001) ; readBits = 16 (0001 0000)
    //assert(HAL.readBits(0b111001) == 0b00010000)
    DEBUG("HAL.readBits test passed")

    // isBit
    // state = 146 (1001 0010) ; mask = 8 (0000 1000) ; isBit = true
    //assert(!HAL.isBit(0b00001000))
    //assert(HAL.isBit(0b00000010))
    DEBUG("HAL.isBit test passed")

    // setBits
    // state = 128 (1000 0000) ; mask = 15 (0000 1111) ; output leds = 143 (1000 1111)
    HAL.lastState = 128
    HAL.setBits(0b00001111)
    DEBUG("running HAL.setBits")
    Time.sleep(1000)

    // clrBits
    // state = 143 (1000 1111) ; mask = 3 (0000 0011) ; output leds = 140 (1000 1100)
    HAL.clrBits(0b00000011)
    DEBUG("running HAL.clrBits")
    Time.sleep(1000)

    // writeBits
    // state = 140 (1000 1100) ; mask = 15 (0000 1111) ; value = 9 (0000 1001) ; LEDS = 137 (1000 1001)
    HAL.writeBits(0b00001111, 0b00001001)
    DEBUG("running HAL.writeBits")
    Time.sleep(1000)

    DEBUG("[HAL::TESTBENCH] Done")
}


