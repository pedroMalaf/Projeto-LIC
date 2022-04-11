import isel.leic.*
import isel.leic.simul.gate.Gate

fun main() {
    HAL.init(255)
    //
}

// Virtualiza o acesso ao sistema UsbPort
object HAL {
    private var lastState = 255  // all pins ON by default

    // Inicia a classe, começando com os bits a [state]
    fun init(state: Int) {
        lastState = state
        UsbPort.write(lastState)
    }

    // Retorna true se o bit tiver o valor lógico ‘1’
    fun isBit(mask: Int): Boolean {
        if (!isPowerOfTwo(mask)) {
            throw Exception("ERRO isBit($mask) @ Mais do que um bit ativo em $mask")
        }

        return readBits(mask) == mask
    }

    // Retorna os valores dos bits representados por mask presentes no UsbPort
    fun readBits(mask: Int) = mask and UsbPort.read()

    // Escreve nos bits representados por mask o valor de value
    fun writeBits(mask: Int, value: Int) {
        val num = mask and value
        val numMask = mask.inv() and lastState
        val newState = numMask or num
        UsbPort.write(newState)
        lastState = newState
    }

    // Coloca os bits representados por mask no valor lógico ‘1’
    fun setBits(mask: Int) {
        val newState = mask or lastState
        UsbPort.write(newState)
        lastState = newState
    }

    // Coloca os bits representados por mask no valor lógico ‘0’
    fun clrBits(mask: Int) {
        val newState = mask.inv() and lastState
        UsbPort.write(newState)
        lastState = newState
    }
}
