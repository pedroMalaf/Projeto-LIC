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
	CL(0) <= '0' when S(0) = '0' and S(1) = '0' else '1';
	CL(1) <= '0' when S(0) = '1' and S(1) = '0' else '1';
	CL(2) <= '0' when S(0) = '0' and S(1) = '1' else '1';
END arq;