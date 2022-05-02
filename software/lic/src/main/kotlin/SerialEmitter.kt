
fun main() {

}

// Envia tramas para os diferentes módulos Serial Receiver
object SerialEmitter {
    enum class Destination {LCD, TICKER_DISPENSER}

    // Inicia a classe
    fun init() {

    }

    // Envia uma trama para o SerielReceiver identificado o destino em addr e os bits de dados em data
    fun send(addr: Destination, data: Int) {
        // 0b1000 0000

    }

    // Retorna true se o canal série estiver ocupado
    fun isBusy(): Boolean {
        return true
    }
}