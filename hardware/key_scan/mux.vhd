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
    Y <= (NOT S(0) AND NOT S(1))
        AND (s(0) AND NOT s(1) AND A(1))
        AND (NOT s(0) AND s(1) AND A(2))
        AND (s(0) AND s(1) AND A(3));
END arq;