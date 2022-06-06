import isel.leic.utils.Time
import java.io.File

/**
 * Simulates a "Coin Acceptor".
 * NOTE: Check documentation for more information about the frame protocols etc etc.
 */
object CoinAcceptor {

    // INPUT PORT
    const val COIN_MASK = 0b10000
    const val CID_MASK = 0b1110 // I3 I2 I1

    // OUTPUT PORT
    const val ACCEPT_MASK = 0x10 // 4
    const val COLLECT_MASK = 0x20 // 5
    const val RETURN_MASK = 0x40 // 6

    // NOTE: cid -> coin value
    private val codification = hashMapOf<Int, Int>(
        0 to 5,
        1 to 10,
        2 to 20,
        3 to 50,
        4 to 100,
        5 to 200

    )

    fun init() {
        File("CoinsDeposit.txt").readLines().forEach {
            val values = it.split(";").map { n -> n.toInt() }
            val (coin, cid) = values[0] to values[1]
            codification[cid] = coin
        }

        DEBUG("[CoinAcceptor::init] codification = $codification")
        HAL.init()
    }

    /**
     * Returns true if a new coin is inserted.
     */
    fun hasCoin() = HAL.isBit(COIN_MASK)

    /**
     * Returns the coin's introduced value.
     */
    fun getCoinValue(): Int {
        val r = HAL.readBits(CID_MASK) shr 1
        DEBUG("[CoinAcceptor::getCoinValue] HAL.readBits = $r")
        codification[r].let {
            return it ?: 0
        }
    }

    /**
     * Accepts the introduced coin.
     */
    fun acceptCoin() {
        HAL.setBits(ACCEPT_MASK)
        while (HAL.isBit(COIN_MASK)) {
            DEBUG("[CoinAcceptor::acceptCoin] waiting for COIN disable")
            Time.sleep(2000)
        }
        Time.sleep(1000)
        HAL.clrBits(ACCEPT_MASK)
    }

    /**
     * "Ejects" the current coins.
     */
    fun ejectCoins() {
        HAL.setBits(RETURN_MASK)
        Time.sleep(2100)
        HAL.clrBits(RETURN_MASK)

    }

    /**
     * Collects the current coins.
     */
    fun collectCoins() {
        HAL.setBits(COLLECT_MASK)
        Time.sleep(2100)
        HAL.clrBits(COLLECT_MASK)
    }

}

fun main() {
    DEBUG("[CoinAcceptor::TESTBENCH] Starting")
    DEBUG("[CoinAcceptor::TESTBENCH] Put ${AS_BINARY(CoinAcceptor.COIN_MASK)} to 0")
    CoinAcceptor.init()
    Time.sleep(5000)

    DEBUG("[CoinAcceptor::TESTBENCH] hasCoin = ${CoinAcceptor.hasCoin()}")
    DEBUG("[CoinAcceptor::TESTBENCH] getCoinValue = ${CoinAcceptor.getCoinValue()}")

    DEBUG("[CoinAcceptor::TESTBENCH] Put ${AS_BINARY(CoinAcceptor.COIN_MASK)} to 1 (insert coin)")
    DEBUG("[CoinAcceptor::TESTBENCH] Put ${AS_BINARY(CoinAcceptor.CID_MASK)} to 010 (0,20€)")
    Time.sleep(5000)

    DEBUG("[CoinAcceptor::TESTBENCH] hasCoin = ${CoinAcceptor.hasCoin()}")
    DEBUG("[CoinAcceptor::TESTBENCH] getCoinValue = ${CoinAcceptor.getCoinValue()}")
    Time.sleep(2000)

    DEBUG("[CoinAcceptor::TESTBENCH] accepting coin")
    CoinAcceptor.acceptCoin()
    DEBUG("[CoinAcceptor::TESTBENCH] coin accepted")
    Time.sleep(2000)


    DEBUG("[CoinAcceptor::TESTBENCH] collecting coins")
    CoinAcceptor.collectCoins()
    DEBUG("[CoinAcceptor::TESTBENCH] coins collected")
    Time.sleep(2000)


    DEBUG("[CoinAcceptor::TESTBENCH] ejecting coins")
    CoinAcceptor.ejectCoins()
    DEBUG("[CoinAcceptor::TESTBENCH] coins ejected")
    Time.sleep(2000)

    DEBUG("[CoinAcceptor::TESTBENCH] Done")

}