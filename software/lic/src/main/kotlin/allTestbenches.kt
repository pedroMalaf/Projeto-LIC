import isel.leic.utils.Time

/**
 * This file contains all the testbenches for our classes
 * To test, uncomment the one you want to test.
 */

fun main() {
    //HAL_Testbench()

    //LCD_Testbench()

    //SerialEmitter_Testbench(0b001000011)

    /* hex: rt | origem | destino */
    //TicketDispenser_Testbench(0b0111, 0b1110, false)
    //TicketDispenser_Testbench(0b0011, 0b1100, false)

    LCD_Testbench()
}

// Testbench (RUN THIS WITH BREAKPOINTS TO DEBUG LEDS)
fun HAL_Testbench() {
    DEBUG("HAL_TESTBENCH")
    // README: turn switches on if testing on real board
    HAL.init(146)

    // readBits
    // state = 146 (1001 0010) ; mask = 57 (0011 1001) ; readBits = 16 (0001 0000)
    //assert(HAL.readBits(0b111001) == 0b00010000)
    println("HAL.readBits test passed")

    // isBit
    // state = 146 (1001 0010) ; mask = 8 (0000 1000) ; isBit = true
    //assert(!HAL.isBit(0b00001000))
    //assert(HAL.isBit(0b00000010))
    println("HAL.isBit test passed")

    // setBits
    // state = 128 (1000 0000) ; mask = 15 (0000 1111) ; output leds = 143 (1000 1111)
    HAL.lastState = 128
    HAL.setBits(0b00001111)
    println("running HAL.setBits")
    Time.sleep(1000)

    // clrBits
    // state = 143 (1000 1111) ; mask = 3 (0000 0011) ; output leds = 140 (1000 1100)
    HAL.clrBits(0b00000011)
    println("running HAL.clrBits")
    Time.sleep(1000)

    // writeBits
    // state = 140 (1000 1100) ; mask = 15 (0000 1111) ; value = 9 (0000 1001) ; LEDS = 137 (1000 1001)
    HAL.writeBits(0b00001111, 0b00001001)
    println("running HAL.writeBits")
    Time.sleep(1000)
}

fun LCD_Testbench() {
    DEBUG("LCD_Testbench")

    LCD.init()
    LCD.writeByte(true, 0b1101_0110)
    Time.sleep(2000)

    LCD.clear()
    LCD.write("hello world")
    Time.sleep(2000)

    LCD.clear()
    LCD.cursor(0, 0)
    LCD.write('a')
    Time.sleep(5000)
}

fun SerialEmitter_Testbench(data: Int) {
    DEBUG("SerialEmitter_Testbench")

    // README: if testing on real board, make sure to manipulate switches (?)
    SerialEmitter.init()
    SerialEmitter.send(SerialEmitter.Destination.TICKER_DISPENSER, data)
}

fun TicketDispenser_Testbench(d: Int, o: Int, rt: Boolean) {
    DEBUG("TicketDispenser_Testbench")

    TicketDispenser.init()
    TicketDispenser.print(d, o, rt)
}