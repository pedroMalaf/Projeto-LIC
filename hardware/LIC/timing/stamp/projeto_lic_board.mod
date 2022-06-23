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
DATE "06/23/2022 13:13:49";
PROGRAM "Quartus Prime";



INPUT Kscan;
INPUT clk;
INPUT reset;
INPUT L[0];
INPUT L[1];
INPUT L[2];
INPUT L[3];
OUTPUT K[0];
OUTPUT K[1];
OUTPUT K[2];
OUTPUT K[3];
OUTPUT C[0];
OUTPUT C[1];
OUTPUT C[2];
OUTPUT Kpress;

/*Arc definitions start here*/

ENDMODEL
