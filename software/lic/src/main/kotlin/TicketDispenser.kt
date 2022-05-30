/**
 * TicketDispenser
 *
 * Prints a frame ticket with destination, origin and round trip bits.
 */
object TicketDispenser {

    fun init() {
        SerialEmitter.init()
    }

    /**
     * Prints the ticket by sending it with information required to SerialEmitter
     */
    fun print(destinyID: Int, originID: Int, roundTrip: Boolean) {
        val RT = if (!roundTrip) 0 else 1
        val data = RT or destinyID.shl(1) or originID.shl(5)
        DEBUG("[TicketDispenser::print] destinyID = ${AS_BINARY(destinyID)}")
        DEBUG("[TicketDispenser::print] originID = ${AS_BINARY(originID)}")
        DEBUG("[TicketDispenser::print] roundTrip = ${AS_BINARY(RT)}")
        DEBUG("[TicketDispenser::print] printing: ${AS_BINARY(data)}")
        SerialEmitter.send(SerialEmitter.Destination.TICKER_DISPENSER, data)
    }
}


