import isel.leic.UsbPort

fun main(args: Array<String>) {
    val value = UsbPort.read()
    println(value)
    UsbPort.write(value)
}