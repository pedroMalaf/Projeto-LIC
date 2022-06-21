import java.io.File

/**
 * Opens file buffer.
 */
fun openFile(fileName: String): File {
    val fp = File(fileName)
    if (!fp.exists())
        throw Exception("$fileName does not exist!")
    return fp
}

/**
 * Reads coins from file and returns a linked hash map with coin -> quantity.
 */
fun File.readCoins() : LinkedHashMap<Int, Int> {
    val tmp = linkedMapOf<Int, Int>()
    this.readLines().forEach { line ->
        val v = line.split(";").map { it.toInt() } // Coin;Quantity
        tmp[v[0]] = v[1]
    }
    return tmp
}

/**
 * Saves coins from memory to file
 */
fun File.saveCoins(coins: LinkedHashMap<Int, Int>) {
    this.bufferedWriter().use {
        for ((coin, quantity) in coins) {
            it.write("$coin;$quantity\n")
        }
    }
}

/**
 * Reads cities from file and returns the list of it
 */
fun File.readCities() : MutableList<Stations.City> {
    val tmp = mutableListOf<Stations.City>()
    this.readLines().forEach { line ->
        val v = line.split(";") // Price;Sold;Name
        tmp.add(Stations.City(v[0].toInt(), v[1].toInt(), v[2]))
    }
    return tmp
}

/**
 * Saves cities from memory to file
 */
fun File.saveCities(cities: MutableList<Stations.City>) {
    this.bufferedWriter().use {
        for (city in cities) {
            it.write("${city.price};${city.sold};${city.name}\n")
        }
    }
}