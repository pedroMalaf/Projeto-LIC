--mux

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
    Y <= (not S(0) AND not S(1))
	 AND (s(0) and not s(1) and A(1))
	 AND (not s(0) and s(1) and A(2))
	 AND (s(0) and s(1) and A(3));
END arq;