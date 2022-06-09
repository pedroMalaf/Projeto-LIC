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
	process (A, S) is 
	begin
		if (S(0) = '0' and S(1) = '0' and A(0) = '1') then
			Y <= '1';
		elsif (S(0) = '1' and S(1) = '0' and A(1) = '1') then
			Y <= '1';
		elsif (S(0) = '0' and S(1) = '1' and A(2) = '1') then 
			Y <= '1';
		elsif (S(0) = '1' and S(1) = '1' and A(3) = '1') then 
			Y <= '1';
		else 
			Y <= '0';
		end if;
	end process;
END arq;