 LIBRARY IEEE;
 USE IEEE.std_logic_1164.ALL;
 
 ENTITY serial_control IS
	PORT (
		SS, accept, pFlag, dFlag, RXerror : IN STD_LOGIC;
		wr, init, DXval, busy : OUT STD_LOGIC;
	);
 END serial_control;
 
 