-- Parity check

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY parity_check IS
	PORT (
		data : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		init : IN STD_LOGIC;
		err : OUT STD_LOGIC
	);
END parity_check;

ARCHITECTURE arq OF parity_check IS

	COMPONENT FFD IS
		PORT (
			CLK : IN STD_LOGIC;
			RESET : IN STD_LOGIC;
			SET : IN STD_LOGIC;
			D : IN STD_LOGIC;
			EN : IN STD_LOGIC;
			Q : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL d, q : STD_LOGIC;

BEGIN
	d <= data XOR q;

	u_ffd0 : FFD
	PORT MAP(
		EN => '1',
		RESET => init,
		SET => '0',
		CLK => clk,
		D => d,
		Q => q
	);

	err <= q;

END arq;