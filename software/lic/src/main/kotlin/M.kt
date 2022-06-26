import isel.leic.utils.Time
import kotlin.test.assertEquals

/**
 * Maintenance mode.
 */
object M {

    /**
     * Inits M.
     */
    fun init() {
        HAL.init()
    }

    /**
     * Returns true if in maintenance mode.
     */
    fun verify() = HAL.isBit(M_MASK)
}

fun main() {
    M_Testbench()
}

fun M_Testbench() {
    DEBUG("[M::TESTBENCH] starting")
    M.init()

    assertEquals(M.verify(), false)

    DEBUG("[M::TESTBENCH] set M to 1 (I7)")
    Time.sleep(5000)
    assertEquals(M.verify(), true)

    DEBUG("[M::TESTBENCH] done")
}