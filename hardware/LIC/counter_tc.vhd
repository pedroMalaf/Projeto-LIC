-- Counter terminal count (will set =10 & =11 flags)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter_tc IS
	PORT (
		D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		TC10 : OUT STD_LOGIC;
		TC11 : OUT STD_LOGIC
	);
END counter_tc;

ARCHITECTURE arq OF counter_tc IS
BEGIN
	TC10 <= D(3) AND NOT(D(2)) AND D(1) AND NOT(D(0)); --10 (1010)
	TC11 <= D(3) AND NOT(D(2)) AND D(1) AND D(0); --11 (1011)
END arq;