import java.io.File

/**
 *
 */
object Stations {

    // File name to read/save.
    private const val FILENAME = "stations.txt"

    // cities
    data class City(val price: Int, var sold: Int, val name: String)
    val cities = mutableListOf<City>()

    /**
     * Inits the object.
     */
    fun init() {
        readFile()
    }

    /**
     * Reads stations.txt file and stores in memory ([cities]).
     * Throws exception in case file does not exist.
     */
    private fun readFile() {
        val fp = File(FILENAME)

        if (!fp.exists())
            throw Exception("$FILENAME does not exist!")

        fp.readLines().forEach { line ->
            val v = line.split(";") // Price;TODO;Name
            cities.add(City(v[0].toInt(), v[1].toInt(), v[2]))
        }

        DEBUG("[Stations::readFile] cities = $cities")
    }

    /**
     * Adds a new sold ticket to the city identified by [name].
     */
    fun addSold(name: String) {
        for (city in cities) {
            if (city.name == name) {
                city.sold++
                return
            }
        }

        throw Exception("City $name does not exist!")
    }

    /**
     * Saves from memory to file.
     */
    fun saveCities() {
        File(FILENAME).bufferedWriter().use {
            for (city in cities) {
                it.write("${city.price};${city.sold};${city.name}\n")
            }
        }

        DEBUG("[CoinDeposit::saveCoins] saved cities)")
    }


}

fun main() {
    Stations_Testbench()
}

fun Stations_Testbench() {
    DEBUG("[Stations::TESTBENCH] starting")
    Stations.init()

    Stations.addSold("Lisboa")
    DEBUG("[Stations::TESTBENCH] added sold to Lisboa")

    Stations.saveCities()

    DEBUG("[Stations::TESTBENCH] done")
}