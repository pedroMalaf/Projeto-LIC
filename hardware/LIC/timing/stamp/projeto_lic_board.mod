/*
 Copyright (C) 2020  Intel Corporation. All rights reserved.
 Your use of Intel Corporation's design tools, logic functions 
 and other software and tools, and any partner logic 
 functions, and any output files from any of the foregoing 
 (including device programming or simulation files), and any 
 associated documentation or information are expressly subject 
 to the terms and conditions of the Intel Program License 
 Subscription Agreement, the Intel Quartus Prime License Agreement,
 the Intel FPGA IP License Agreement, or other applicable license
 agreement, including, without limitation, that your use is for
 the sole purpose of programming logic devices manufactured by
 Intel and sold by Intel or its authorized distributors.  Please
 refer to the applicable agreement for further details, at
 https://fpgasoftware.intel.com/eula.
*/
MODEL
/*MODEL HEADER*/
/*
 This file contains Slow Corner delays for the design using part 10M50DAF484C6GES
 with speed grade 6, core voltage 1.2V, and temperature 85 Celsius

*/
MODEL_VERSION "1.0";
DESIGN "projeto_lic";
DATE "07/06/2022 15:42:41";
PROGRAM "Quartus Prime";



INPUT MCLK;
INPUT altera_reserved_tdi;
INPUT altera_reserved_tck;
INPUT altera_reserved_tms;
INPUT collect;
INPUT coins[1];
INPUT coins[2];
INPUT CoinInserted;
INPUT Maintenance;
INPUT KEYPAD_LIN[2];
INPUT KEYPAD_LIN[0];
INPUT KEYPAD_LIN[1];
INPUT KEYPAD_LIN[3];
INPUT Reset;
INPUT coins[0];
INPUT coins[3];
OUTPUT Prt;
OUTPUT HEX0[0];
OUTPUT HEX0[1];
OUTPUT HEX0[2];
OUTPUT HEX0[3];
OUTPUT HEX0[4];
OUTPUT HEX0[5];
OUTPUT HEX0[6];
OUTPUT HEX0[7];
OUTPUT HEX1[0];
OUTPUT HEX1[1];
OUTPUT HEX1[2];
OUTPUT HEX1[3];
OUTPUT HEX1[4];
OUTPUT HEX1[5];
OUTPUT HEX1[6];
OUTPUT HEX1[7];
OUTPUT HEX2[0];
OUTPUT HEX2[1];
OUTPUT HEX2[2];
OUTPUT HEX2[3];
OUTPUT HEX2[4];
OUTPUT HEX2[5];
OUTPUT HEX2[6];
OUTPUT HEX2[7];
OUTPUT LCD_RS;
OUTPUT LCD_EN;
OUTPUT LCD_DATA[0];
OUTPUT LCD_DATA[1];
OUTPUT LCD_DATA[2];
OUTPUT LCD_DATA[3];
OUTPUT LCD_DATA[4];
OUTPUT LCD_DATA[5];
OUTPUT LCD_DATA[6];
OUTPUT LCD_DATA[7];
OUTPUT KEYPAD_COL[0];
OUTPUT KEYPAD_COL[1];
OUTPUT KEYPAD_COL[2];
OUTPUT accept;
OUTPUT collect_coin;
OUTPUT eject;
OUTPUT altera_reserved_tdo;

/*Arc definitions start here*/
pos_CoinInserted__altera_reserved_tck__setup:		SETUP (POSEDGE) CoinInserted altera_reserved_tck ;
pos_Maintenance__altera_reserved_tck__setup:		SETUP (POSEDGE) Maintenance altera_reserved_tck ;
pos_altera_reserved_tdi__altera_reserved_tck__setup:		SETUP (POSEDGE) altera_reserved_tdi altera_reserved_tck ;
pos_altera_reserved_tms__altera_reserved_tck__setup:		SETUP (POSEDGE) altera_reserved_tms altera_reserved_tck ;
pos_coins[0]__altera_reserved_tck__setup:		SETUP (POSEDGE) coins[0] altera_reserved_tck ;
pos_coins[1]__altera_reserved_tck__setup:		SETUP (POSEDGE) coins[1] altera_reserved_tck ;
pos_coins[2]__altera_reserved_tck__setup:		SETUP (POSEDGE) coins[2] altera_reserved_tck ;
pos_collect__altera_reserved_tck__setup:		SETUP (POSEDGE) collect altera_reserved_tck ;
pos_CoinInserted__altera_reserved_tck__hold:		HOLD (POSEDGE) CoinInserted altera_reserved_tck ;
pos_Maintenance__altera_reserved_tck__hold:		HOLD (POSEDGE) Maintenance altera_reserved_tck ;
pos_altera_reserved_tdi__altera_reserved_tck__hold:		HOLD (POSEDGE) altera_reserved_tdi altera_reserved_tck ;
pos_altera_reserved_tms__altera_reserved_tck__hold:		HOLD (POSEDGE) altera_reserved_tms altera_reserved_tck ;
pos_coins[0]__altera_reserved_tck__hold:		HOLD (POSEDGE) coins[0] altera_reserved_tck ;
pos_coins[1]__altera_reserved_tck__hold:		HOLD (POSEDGE) coins[1] altera_reserved_tck ;
pos_coins[2]__altera_reserved_tck__hold:		HOLD (POSEDGE) coins[2] altera_reserved_tck ;
pos_collect__altera_reserved_tck__hold:		HOLD (POSEDGE) collect altera_reserved_tck ;
pos_altera_reserved_tck__accept__delay:		DELAY (POSEDGE) altera_reserved_tck accept ;
pos_altera_reserved_tck__altera_reserved_tdo__delay:		DELAY (POSEDGE) altera_reserved_tck altera_reserved_tdo ;
pos_altera_reserved_tck__collect_coin__delay:		DELAY (POSEDGE) altera_reserved_tck collect_coin ;
pos_altera_reserved_tck__eject__delay:		DELAY (POSEDGE) altera_reserved_tck eject ;

ENDMODEL
