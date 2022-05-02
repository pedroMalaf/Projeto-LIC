import isel.leic.UsbPort

fun main() {
    HALTestbench()
}

/**
 * HAL
 *
 * Virtualiza o acesso ao sistema UsbPort
 */
object HAL {
    var lastState = 255  // all pins ON by default

    // Muda o estado dos output leds para [newState]
    private fun changeState(newState: Int) {
        UsbPort.write(newState)
        lastState = newState
    }

    // Inicia a classe, começando com os bits a [state]
    fun init(state: Int) {
        changeState(state)
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
        changeState(numMask or num)
    }

    // Coloca os bits representados por mask no valor lógico ‘1’
    fun setBits(mask: Int) {
        changeState(mask or lastState)
    }

    // Coloca os bits representados por mask no valor lógico ‘0’
    fun clrBits(mask: Int) {
        changeState(mask.inv() and lastState)
    }
}

// Testbench (RUN THIS WITH BREAKPOINTS TO DEBUG LEDS)
fun HALTestbench() {
    HAL.init(146)

    // readBits
    // state = 146 (1001 0010) ; mask = 57 (0011 1001) ; readBits = 16 (0001 0000)
    assert(HAL.readBits(0b111001) == 0b00010000)
    println("HAL.readBits test passed")

    // isBit
    // state = 146 (1001 0010) ; mask = 8 (0000 1000) ; isBit = true
    assert(HAL.isBit(0b00001000))
    // state = 146 (1001 0010) ; mask = 0 (0000 0000) ; isBit = false
    assert(!HAL.isBit(0))
    println("HAL.isBit test passed")

    // setBits
    // state = 128 (1000 0000) ; mask = 15 (0000 1111) ; output leds = 143 (1000 1111)
    HAL.lastState = 128
    HAL.setBits(0b00001111)
    println("running HAL.setBits")

    // clrBits
    // state = 143 (1000 1111) ; mask = 3 (0000 0011) ; output leds = 140 (1000 1100)
    HAL.clrBits(0b00000011)
    println("running HAL.clrBits")

    // writeBits
    // state = 140 (1000 1100) ; mask = 15 (0000 1111) ; value = 9 (0000 1001) ;  output leds = 137 (1000 1001)
    HAL.writeBits(0b00001111, 0b00001001)
    println("running HAL.writeBits")
}