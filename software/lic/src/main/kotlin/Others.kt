import isel.leic.utils.Time
import java.io.File

// Some utilities

/**
 * Returns time elapsed since [t].
 */
fun elapsed(t: Long) = Time.getTimeInMillis() - t

/**
 * Returns true if [n] is power of 2.
 */
fun isPowerOfTwo(n: Int) = (n and (n-1)) == 0

/**
 * Returns [n] in decimal, hex and binary.
 */
fun printNum(n: Int) =
    "%d (0x%x) (0b%s)".format(n, n, n.toString(2))

/**
 * Returns [n] in binary.
 */
fun AS_BINARY(n: Int) =
    "0b%s".format(n.toString(2))

var DEBUG_MODE = -1


/**
 * Debugs aKa prints [s] to console if debug mode is set.
 * You can set/unset debug mode in debug.txt.
 */
fun DEBUG(s: String) {
    when(DEBUG_MODE) {
        0 -> return
        1 -> println(s)
        else -> {
            val l = File("debug.txt").readLines(Charsets.UTF_8)[0]
            if (!l.contains("debug = ") || !l.last().isDigit()) {
                throw Exception("debug.txt invalid configuration! Make sure it contains \"debug = 0/1\" ")
            }
            DEBUG_MODE = l.last().toString().toInt()
            DEBUG_MODE = if (DEBUG_MODE == 0) 0 else 1 // avoid stack overflow
            DEBUG(s)
        }
    }
}

/**
 * Returns [d] into string with decimal places represented as euros.
 * This function should be used to convert i.e 250 cents to 2.50 euro.
 */
fun centsToString(d: Int) = String.format("%.2f", d.toDouble() * 0.01).replace(',', '.')
