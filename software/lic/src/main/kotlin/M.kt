object M {

    fun init() {
        HAL.init()
    }

    fun verify(): Boolean {
        val ver = HAL.isBit(0b1000_0000)
        return ver
    }
}

