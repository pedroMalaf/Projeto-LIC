object TicketDispenser {
    fun init() {
        serialEmitter.init()
    }

    fun print(destinyID: Int, originID: Int, roundTrip: Boolean) {

        var newRT = 0
        if( roundTrip == false ) newRT = 0 else newRT = 1

        val data = newRT or destinyID.shl(1) or originID.shl(5)

        serialEmitter.send(TICKET_DISPENSER, data)
    }
}


