-- decoder 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY dec IS
	PORT (
		S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CL : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END dec;

ARCHITECTURE arq OF dec IS
BEGIN
	CL(0) <= not S(0) and not S(1);
	CL(1) <= S(0) and not S(1);
	CL(2) <= not S(0) and S(1);
END arq;