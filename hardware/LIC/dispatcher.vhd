-- IOS Dispatcher TODO

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dispatcher IS
	PORT (
		Fsh, Dval : IN STD_LOGIC;
		Din : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		Dout : OUT STD_LOGIC_VECTOR(7 downto 0);
		WrT, WrL : out std_logic;
		done : out std_logic
	);
END dispatcher;

ARCHITECTURE arq OF dispatcher IS

BEGIN
	
END arq;