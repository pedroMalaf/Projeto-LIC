import java.io.File

/**
 *
 */
object CoinDeposit {

    // File name to read/save.
    private const val FILENAME = "CoinDeposit.txt"

    // Coin -> Quantity
    var coins = linkedMapOf<Int, Int>() // not hashmap because order is important

    /**
     * Inits the object.
     */
    fun init() {
        readFile()
    }

    /**
     * Reads CoinDeposit.txt file and stores coin and its quantity in memory ([coins])
     * Throws exception in case file does not exist
     */
    private fun readFile() {
        coins = openFile(FILENAME).readCoins()
        DEBUG("[CoinDeposit::readFile] coins = $coins")
    }

    /**
     * Inserts a coin, identified by [coin]
     */
    fun insertCoin(coin: Int): Int? {
        if (coins[coin] == null)
            return null

        coins[coin] = coins[coin]!!.plus(1)
        return coins[coin]
    }

    /**
     * Saves coins and quantity from memory to file.
     */
    fun saveCoins() {
        openFile(FILENAME).saveCoins(coins)
        DEBUG("[CoinDeposit::saveCoins] saved coins = $coins")
    }

    /**
     * Resets quantity of each coin.
     */
    fun resetQuantity() {
        for (k in coins.keys) {
            coins[k] = 0
        }
    }
}

fun main() {
    CoinDeposit_Testbench()
}

fun CoinDeposit_Testbench() {
    DEBUG("[CoinDeposit::TESTBENCH] starting")
    CoinDeposit.init()

    CoinDeposit.coins[5] = 200
    CoinDeposit.saveCoins()
    DEBUG("[CoinDeposit::TESTBENCH] saved with 5 = 200 (check file)")

    CoinDeposit.resetQuantity()
    DEBUG("[CoinDeposit::TESTBENCH] after resetQuantity: ${CoinDeposit.coins}")

    println(CoinDeposit.insertCoin(200))
    DEBUG("[CoinDeposit::TESTBENCH] after insertCoin(200): ${CoinDeposit.coins}")

    CoinDeposit.saveCoins()

    DEBUG("[CoinDeposit::TESTBENCH] done")
}