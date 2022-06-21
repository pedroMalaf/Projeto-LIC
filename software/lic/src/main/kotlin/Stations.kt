import java.io.File

/**
 * Functions to work with station tickets (cities and prices)
 */
object Stations {

    // File name to read/save.
    private const val FILENAME = "stations.txt"

    // cities
    data class City(val price: Int, var sold: Int, val name: String)
    var cities = mutableListOf<City>()

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
        cities = openFile(FILENAME).readCities()
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
        openFile(FILENAME).saveCities(cities)
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