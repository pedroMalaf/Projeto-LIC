-- Register (4 bit)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg IS
	PORT (
		F : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		CE, RESET : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END reg;

ARCHITECTURE arq OF reg IS

	COMPONENT FFD
		PORT (
			CLK, D, EN, SET, RESET : IN STD_LOGIC;
			Q : OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN
	u_FFD0 : FFD
	PORT MAP(
		D => F(0),
		EN => CE,
		CLK => CLK,
		Q => Q(0),
		SET => '0',
		RESET => RESET
	);

	u_FFD1 : FFD
	PORT MAP(
		D => F(1),
		EN => CE,
		CLK => CLK,
		Q => Q(1),
		SET => '0',
		RESET => RESET
	);

	u_FFD2 : FFD
	PORT MAP(
		D => F(2),
		EN => CE,
		CLK => CLK,
		Q => Q(2),
		SET => '0',
		RESET => RESET
	);

	u_FFD3 : FFD
	PORT MAP(
		D => F(3),
		EN => CE,
		CLK => CLK,
		Q => Q(3),
		SET => '0',
		RESET => RESET
	);

END arq;