// Some utilities

/**
 * Returns true if [n] is power of 2.
 */
fun isPowerOfTwo(n: Int) = (n and (n-1)) == 0

/**
 * Prints [n] in decimal, hex and binary.
 */
fun printNum(n: Int) {
    println("%d (0x%x) (0b%s)".format(n, n, n.toString(2)))
}
