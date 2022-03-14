 LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
 
ENTITY parity_check IS
	PORT (
		data, init, clk : IN STD_LOGIC;
		err : OUT STD_LOGIC;
	);
END parity_check;

 