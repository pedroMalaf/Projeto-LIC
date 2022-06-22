-- key transmitter counter


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY KT_counter IS
	PORT(	
		reset : IN STD_LOGIC;
		CE, CLK: IN STD_LOGIC;
		TC: OUT STD_LOGIC;
		Count : OUT STD_LOGIC_VECTOR(2 downto 0)
	);
END KT_counter;

ARCHITECTURE arq OF KT_counter IS

	COMPONENT FFD
		PORT(
			CLK : IN STD_LOGIC;
			RESET : IN STD_LOGIC;
			D : IN STD_LOGIC;
			EN : IN STD_LOGIC;
			Q : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL Qout: STD_LOGIC_VECTOR (2 downto 0);
	SIGNAL sD: STD_LOGIC_VECTOR (2 downto 0);


BEGIN

	sD(0) <= CE xor Qout(0);
	sD(1) <= (Qout(0) and CE) xor Qout(1);
	sD(2) <= (Qout(1) and (Qout(0) and CE)) xor Qout(2);


	UFFD0: FFD 
		PORT MAP(
			CLK => CLK,
			EN => CE,
			RESET => reset,
			D => sD(0),
			Q => Qout(0)
		);
			
	UFFD1: FFD 
		PORT MAP(
			CLK => CLK,
			EN => CE,
			RESET => reset,
			D => sD(1),
			Q => Qout(1)
		);
		
	UFFD2: FFD 
		PORT MAP(
			CLK => CLK,
			EN => CE,
			RESET => reset,
			D => sD(2),
			Q => Qout(2)
		);
		

	TC <= Qout(0) AND Qout(1) AND Qout(2);
	Count	 <= Qout;
	
END arq;