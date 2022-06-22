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
     * Removes and exchanges coins inserted.
     */
    fun returnValue(total: Int) {
        var resto = total

        val dois_euros = 200 to resto / 200
        resto %= 200

        val euros = 100 to resto / 100
        resto %= 100

        val meio_euro = 50 to resto / 50
        resto %= 50

        val vinte_cent = 20 to resto / 20
        resto %= 20

        val dez_cent = 10 to resto / 10
        resto %= 10

        val cinco_cent = 5 to resto / 5
        resto %= 5

        coins[dois_euros.first] = coins[dois_euros.first]!!.minus(dois_euros.second)
        coins[euros.first] = coins[euros.first]!!.minus(euros.second)
        coins[meio_euro.first] = coins[meio_euro.first]!!.minus(meio_euro.second)
        coins[vinte_cent.first] = coins[vinte_cent.first]!!.minus(vinte_cent.second)
        coins[dez_cent.first] = coins[dez_cent.first]!!.minus(dez_cent.second)
        coins[cinco_cent.first] = coins[cinco_cent.first]!!.minus(cinco_cent.second)
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

    DEBUG("[CoinDeposit::TESTBENCH] return value(200): ")
    println(CoinDeposit.returnValue(205))

    CoinDeposit.saveCoins()

    DEBUG("[CoinDeposit::TESTBENCH] done")
}