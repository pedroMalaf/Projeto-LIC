-- mux 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY mux IS
    PORT (
        S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Y : OUT STD_LOGIC
    );
END mux;

ARCHITECTURE arq OF mux IS
BEGIN
	Y <= '1' WHEN (S(0) = '0' and S(1) = '0' and S(0) = '1')
	OR
	(S(0) = '0' and S(1) = '1' and S(1) = '1')
	OR
	(S(0) = '1' and S(1) = '0' and S(2) = '1')
	OR
	(S(0) = '1' and S(1) = '1' and S(3) = '1')
	ELSE '0';
END arq;