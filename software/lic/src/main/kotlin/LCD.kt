class LCD {
    private val LINES = 2 //dimensão do display
    private val COLS = 16 //dimensão do display

    //escreve um byte de comando/dados no LCD em série
    private fun writeByteSerial(rs: Boolean, data: Int){

    }

    //escreve um byte de comando/dados no LCD
    private fun writeByte(rs: Boolean, data: Int){

    }

    //escreve um comando no lcd
    private fun writeCMD(data: Int){

    }

    //escreve um dado no LCD
    private fun writeDATA(data: Int){

    }

    //envia uma sequência de iniciação para comunicação a 8 bits
    fun init(){

    }

    //escreve um carácter na posição corrente
    fun write(c: Char){

    }

    //escreve uma string na posição corrente
    fun write(text: String){

    }

    //envia um comando para posicionar cursor ('line':0..LINES-1, 'column':0..COLS-1)
    fun cursor(line: Int, column: Int){

    }

    //envia um comando para limpar o ecrã e posicionar o cursor em (0,0)
    fun clear(){

    }
}