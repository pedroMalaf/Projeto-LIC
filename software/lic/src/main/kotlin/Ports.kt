/**
 * Ports.kt
 *
 * This file contains all the masks+ports for the UsbPort.
 */

// INPUT PORT
const val BUSY_MASK = 0x1 // I0
const val CID_MASK = 0b1110 // I3 I2 I1
const val COIN_MASK = 0b10000 // I4
const val TXD_MASK = 0b100000 // I5
const val M_MASK = 0b1000_0000 // I7

// OUTPUT PORT
const val TXCLK_MASK = 0x01 // O0
const val NOTSS_MASK = 0x2 // O1
const val SCLK_MASK = 0x4 // O2
const val SDX_MASK = 0x8 // O3
const val ACCEPT_MASK = 0x10 // O4
const val COLLECT_MASK = 0x20 // O5
const val RETURN_MASK = 0x40 // O6
