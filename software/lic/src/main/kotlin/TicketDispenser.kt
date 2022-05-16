import isel.leic.utils.Time

fun main() {
    // 0010 0001 1
    TestbenchTicketDispenser(1, 2, true)
}

/**
 * TicketDispenser
 *
 * Cria uma trama (bilhete) com o destino, origem e round trip
 */
object TicketDispenser {
    fun init() {
        SerialEmitter.init()
    }

    // Envia uma trama recorrendo ao SerialEmitter
    fun print(destinyID: Int, originID: Int, roundTrip: Boolean) {
        while (!SerialEmitter.isBusy()) {
            Time.sleep(3000);
            println("Não é possivel enviar trama agora, tentando novamente em 3 segundos")
        }

        val RT = if (!roundTrip) 0 else 1
        val data = RT or destinyID.shl(1) or originID.shl(5)
        SerialEmitter.send(SerialEmitter.Destination.TICKER_DISPENSER, data)
    }
}

fun TestbenchTicketDispenser(d: Int, o: Int, rt: Boolean) {
    TicketDispenser.init()
    TicketDispenser.print(d, o, rt)
}


