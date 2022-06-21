import java.io.File

/**
 *
 */
object CoinDeposit {

    // File name to read/save.
    private const val FILENAME = "CoinDeposit.txt"

    // Coin -> Quantity
    val coins = linkedMapOf<Int, Int>() // not hashmap because order is important

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
        val fp = File(FILENAME)

        if (!fp.exists())
            throw Exception("$FILENAME does not exist!")

        fp.readLines().forEach { line ->
            val v = line.split(";").map { it.toInt() } // Coin;Quantity
            coins[v[0]] = v[1]
        }

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
        File(FILENAME).bufferedWriter().use {
            for ((coin, quantity) in coins) {
                it.write("$coin;$quantity\n")
            }
        }

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